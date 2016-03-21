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
  end

  def find_match
    $redis.hset(uuid, "state", "finding_match")
    Matchmake.create(uuid)
  end

  def find_cancel
    $redis.hset(uuid, "state", "idle")
    Matchmake.remove(uuid)
  end

end
