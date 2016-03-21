# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class GamesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "player_#{uuid}"
    $redis.hset(uuid, "state", "idle")
    ActionCable.server.broadcast "player_#{uuid}", {action: "game_start", msg: "red"}
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    $redis.hset(uuid, "state", "offline")
    Seek.remove(uuid)
  end

  def find_match
    $redis.hset(uuid, "state", "finding_match")
    Seek.create(uuid)
  end

  def find_cancel
    $redis.hset(uuid, "state", "idle")
    Seek.remove(uuid)
  end

end
