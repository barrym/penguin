module Penguin
  class Daemon

    attr_reader :d_id, :name, :pid, :started_at, :uptime, :spawn_count

    def initialize(data)
      # This can go stale - refresh data every time a method is called? hmm
      @d_id = data["d_id"]
      @name = data["name"]
      @pid = data["pid"].to_i
      @started_at = Time.parse(data["started_at"])
      @uptime = data["uptime"].to_i
      @spawn_count = data["spawn_count"].to_i
      @monitored = data["monitored"]
      @up = data["up"]
    end

    def monitored?
      @monitored
    end

    def running?
      @up
    end

  end
end
