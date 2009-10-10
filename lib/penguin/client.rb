module Penguin
  class Client

    def initialize(port = nil)
      # TODO: fix this
      unless port
        details = Monitor.get_details
        port = details[:port]
      end
      @server = TCPSocket.new('localhost', port)
    end

    def status
      send("status")
      JSON.parse(get_reply)
    end

    def daemons
      _daemons = []
      status["daemons"].each do |d_id, data|
        _daemons << Penguin::Daemon.new(data.merge("d_id" => d_id))
      end
      _daemons
    end

    def kill(daemon_id)
      send("kill #{daemon_id}")
      get_reply
    end

    def killall
      send("killall")
      get_reply
    end

    def monitor(daemon_id)
      send("monitor #{daemon_id}")
      get_reply
    end

    def unmonitor(daemon_id)
      send("unmonitor #{daemon_id}")
      get_reply
    end

    def stats
    end

    def restart(daemon_id)
      monitor(daemon_id)
      kill(daemon_id)
    end

    def debug(daemon_id)
      send("debug #{daemon_id}")
      get_reply
    end

    def start(daemon_id)
    end

    def stop(daemon_id)
      unmonitor(daemon_id)
      kill(daemon_id)
    end

    private

    def send(command)
      @server.send("#{command}\r\n", 0)
    end

    def get_reply
      reply = nil
      timeout(5) do
        reply = @server.gets
      end
      reply.chomp
    end

  end
end
