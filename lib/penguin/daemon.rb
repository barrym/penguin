module Penguin
  # This is only used by the client, might need to be changed if Process becomes Daemon
  class Daemon

    attr_reader :d_id, :name, :pid, :started_at, :uptime, :spawn_count

    # Remember : this data can become out of date the longer the object is in use
    def initialize(data)
      @d_id        = data["d_id"]
      @name        = data["name"]
      @pid         = data["pid"].to_i
      @started_at  = Time.parse(data["started_at"])
      @uptime      = data["uptime"].to_i
      @spawn_count = data["spawn_count"].to_i
      @monitored   = data["monitored"]
      @up          = data["up"]
    end

    def monitored?
      @monitored
    end

    def running?
      @up
    end
  end
end
