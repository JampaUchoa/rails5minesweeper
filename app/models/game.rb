class Game < ApplicationRecord

  def self.start(uuid1, uuid2)
    game = Game.new
    game.generate_board(12,12,24)
    game.save

    red, blue = [uuid1, uuid2].shuffle

    ActionCable.server.broadcast "player_#{red}", {action: "game_start", msg: "red"}
    ActionCable.server.broadcast "player_#{blue}", {action: "game_start", msg: "blue"}

    $redis.hset(uuid1, "opponent_uuid", uuid2)
    $redis.hset(uuid2, "opponent_uuid", uuid1)

    $redis.hset(uuid1, "game_id", game.id)
    $redis.hset(uuid2, "game_id", game.id)
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
