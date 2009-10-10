module Penguin
  module Monitor

    DEFAULT_PID_DIRECTORY = "./pids"

    # Rename and refactor
    def self.get_details
      if self.pid_file
        port, pid = File.read(self.pid_file).chomp.split(",")
        {:port => port, :pid => pid}
      else
        raise "Not running. fix this exception"
      end
    end

    def self.add_daemon(d)
      (@daemons ||= []) << d
    end

    def self.start
      if File.exist?(self.pid_file)
        port, pid = File.read(self.pid_file).chomp.split(",")
        puts "PID file exists! pid:#{pid} port:#{port}"
        exit
        # try and connect see if it is running etc..
      end

      @started_at = Time.now

      @daemons.each do |d|
        Thread.new do
          d.spawn
        end
      end
      self.monitor
    end

    def self.pid_file_directory
      self::DEFAULT_PID_DIRECTORY
    end

    def self.pid_file
      self.pid_file_directory + "/monitor.pid"
    end

    def self.remove_pid_file
      puts "Removing monitor PID"
      FileUtils.rm(self.pid_file) if File.exists?(self.pid_file)
    end

    def self.kill_all
      # even unmonitored
      @daemons.each { |d| d.kill }
    end

    def self.kill(id)
      @daemons[id].kill if @daemons[id]
    end

    def self.monitor_daemon(id)
      @daemons[id].monitor if @daemons[id]
    end

    def self.unmonitor_daemon(id)
      @daemons[id].unmonitor if @daemons[id]
    end

    def self.debug_daemon(id)
      @daemons[id].debug if @daemons[id]
    end

    def receive_data(data)
      command, args = get_command(data)

      case command
      when :stats
        _send_data("Stats go here")
      when :status
        _send_data(Penguin::Monitor.daemon_status.to_json)
      when :killall
        _send_data("Killing all daemons")
        Penguin::Monitor.cleanup_and_exit
      when :kill
        Penguin::Monitor.kill(args)
        # error checking needed
        _send_data("TODO")
      when :unmonitor
        Penguin::Monitor.unmonitor_daemon(args)
        _send_data("TODO")
      when :monitor
        Penguin::Monitor.monitor_daemon(args)
        _send_data("TODO")
      when :debug
        Penguin::Monitor.debug_daemon(args)
        _send_data("TODO")
      end
    end

    def get_command(data)
      data.chomp!

      case data
      when /^status$/i
        return :status, nil
      when /^stats$/i
        return :stats, nil
      when /^killall$/i
        return :killall, nil
      when /^kill (\d+)$/
        return :kill, $1.to_i
      when /^monitor (\d+)$/i
        return :monitor, $1.to_i
      when /^unmonitor (\d+)$/i
        return :unmonitor, $1.to_i
      when /^debug (\d+)$/i
        return :debug, $1.to_i
      end
    end

    # Is this bad form?
    def _send_data(data)
      send_data(data + "\r\n")
    end

    def self.monitor
      Signal.trap("TERM") { self.cleanup_and_exit }
      EM.run do
        conn = EM.start_server '0.0.0.0', 0, self
        sock = EM.get_sockname(conn)
        port,_ = Socket.unpack_sockaddr_in(sock)

        puts "Started monitor port:#{port} pid:#{$$}"

        # Write monitor PID file
        unless File.exist?(self.pid_file_directory)
          FileUtils.mkdir_p(self.pid_file_directory)
          # Add error checking
        end
        File.open(self.pid_file, "w") do |f|
          f.puts [port,$$].join(",")
        end


        EM.add_periodic_timer(5) do
          self.check_daemons
        end
      end
    rescue Interrupt
      puts "monitor caught Interrupt"
      self.cleanup_and_exit
    end

    def self.daemon_status
      status = {
        :started_at => @started_at,
        :uptime => Time.now.to_i - @started_at.to_i,
        :daemons => {}
      }
      @daemons.each_with_index do |d,id|
        status[:daemons][id] = {
          :name => d.name,
          :up => d.running?,
          :pid => d.pid, # this wont handle non running daemons
          :started_at => d.started_at,
          :uptime => Time.now.to_i - d.started_at.to_i,
          :spawn_count => d.spawn_count,
          :monitored => d.monitored
        }
      end
      status
    end

    def self.check_daemons
      puts "-----------------------------"
      puts "Checking daemon status"
      @daemons.select { |d| d.monitored }.each do |d|
        case d.running?
        when true
          puts "#{d.pid} is UP   [#{d.name}]"
        when false
          puts "#{d.pid} is DOWN [#{d.name}]"
          puts "Restarting:"
          Thread.new do
            d.spawn
          end
        end
      end
      puts "-----------------------------"
    end

    def self.cleanup_and_exit
      self.kill_all
      self.remove_pid_file
      puts "Exiting monitor"
      exit
    end

  end
end
