# Create a new Redis client with the correct config
module NewRedisInstance
  def self.call
    Redis.new(url: ENV.fetch('REDISTOGO_URL'))
  end
end
