class Game < ApplicationRecord

  def self.start(uuid1, uuid2)
    size_x = 16
    size_y = 16
    bombs = (size_x * size_y) / 5.75

    game = Game.new
    game.generate_board(size_x, size_y,bombs)
    game.save

    red, blue = [uuid1, uuid2].shuffle

    ActionCable.server.broadcast "player_#{red}", {context: "game_start", size_x: size_x, size_y: size_y, bombs: bombs, team: "red"}
    ActionCable.server.broadcast "player_#{blue}", {context: "game_start", size_x: size_x, size_y: size_y, bombs: bombs, team: "blue"}

    $redis.hmset(uuid1, "opponent_uuid", uuid2,
                        "game_id", game.id,
                        "state", "in_game")

    $redis.hmset(uuid2, "opponent_uuid", uuid1,
                        "game_id", game.id,
                        "state", "in_game")

    $redis.hmset(game.id, "board", game.board.to_json,
                          "bombs", bombs,
                          "size_y", size_y,
                          "size_x", size_x,
                          "player_red", red,
                          "player_blue", blue,
                          "current_player", blue,
                          "#{red}_score", 0,
                          "#{blue}_score", 0)
  end

  def self.move(uuid,data)
    game = $redis.hget(uuid, "game_id")
    current_player = $redis.hget(game, "current_player")
    opponent_uuid = $redis.hget(uuid, "opponent_uuid")
    y = data["y"].to_i
    x = data["x"].to_i
    if game.present? && current_player == uuid
      board = eval($redis.hget(game, "board"))
      field = board[y][x]
      ActionCable.server.broadcast "player_#{uuid}", {context: "board_reveal", pos_x: x, pos_y: y, field_obj: field}
      ActionCable.server.broadcast "player_#{opponent_uuid}", {context: "board_reveal", pos_x: x, pos_y: y, field_obj: field}
      if field == "b"
        $redis.hincrby(game, "#{uuid}_score", 1)
        if $redis.hget(game, "#{uuid}_score") > ($redis.hget(game, "bombs").to_i / 2.0)
          Game.winner(uuid)
        end
      else
        $redis.hset(game, "current_player", opponent_uuid)
      end
    end
  end

  def self.winner(uuid)
    game_id = $redis.hget(uuid, "game_id")
    game = Game.find(game_id)
    game.winner_uuid = uuid
    game.winner_score = $redis.hget(game, "#{uuid}_score")
    game.save

    ActionCable.server.broadcast "player_#{uuid}", {context: "game_end", winner: "you"}
    ActionCable.server.broadcast "player_#{opponent_uuid}", {context: "game_end", winner: "opponent"}

    opponent_uuid = $redis.hget(uuid, "opponent_uuid")

    $redis.hmset(uuid, "game_id", nil,
                       "opponent_uuid", nil,
                       "state", "idle")

    $redis.hmset(opponent_uuid, "game_id", nil,
                                "opponent_uuid", nil,
                                "state", "idle")
  end

  def generate_board(x_size, y_size, bombs)
    #Creation process
    self.board = []
    self.size_y = y_size
    self.size_x = x_size
    self.bombs = bombs
    self.fog = []

    y_size.times do |i|
      self.board << []
      self.fog << []
      x_size.times do |j|
        self.board[i] << 0
        self.fog[i] << 0
      end
    end

    # bombing process
    remaining_bombs = bombs
    while remaining_bombs > 0
      rng_x = rand(x_size)
      rng_y = rand(y_size)
      if self.board[rng_y][rng_x] != "b"
        self.board[rng_y][rng_x] = "b"
        remaining_bombs -= 1
      end
    end
    # Warns
    y_size.times do |i|
      x_size.times do |j|
        if self.board[i][j] == "b"
          warn_sign(i, j, x_size, y_size)
        end
      end
    end
  end


  def warn_sign(i, j, x_size, y_size)
    3.times do |k|
      pos_y = i + k - 1
      if bound_check(pos_y, y_size)
        3.times do |h|
          pos_x = j + h - 1
          if bound_check(pos_x, x_size)
            if self.board[pos_y][pos_x] != "b"
              self.board[pos_y][pos_x] += 1
            end
          end
        end
      end
    end
  end

  def bound_check(pos, size)
    pos <= size - 1 && pos >= 0
  end

end
