# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class GamesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "player_#{uuid}"
    $redis.hset(uuid, "state", "idle")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    $redis.hset(uuid, "state", "offline")
    Matchmake.remove(uuid)

    opponent_uuid = $redis.hget(uuid, "opponent_uuid")
    if !opponent_uuid.nil?
      Game.winner(opponent_uuid)
    end
  end

  def find_match
    $redis.hset(uuid, "state", "finding_match")
    Matchmake.create(uuid)
  end

  def find_cancel
    $redis.hset(uuid, "state", "idle")
    Matchmake.remove(uuid)
  end

  def move(data)
    Game.move(uuid, data)
  end

end
