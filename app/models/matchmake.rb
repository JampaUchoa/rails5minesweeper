class Matchmake < ApplicationRecord
  def self.create(uuid)
    if opponent = $redis.spop("seeks")
      Game.start(uuid, opponent)
    else
      $redis.sadd("seeks", uuid)
    end
  end

  def self.remove(uuid)
    $redis.srem("seeks", uuid)
  end

  def self.clear_all
    $redis.del("seeks")
  end
end
