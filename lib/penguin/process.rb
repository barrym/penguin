module Penguin
  class Process

    attr_reader :pid
    attr_accessor :command, :name, :started_at, :spawn_count, :monitored

    # second argument of pid for creating new process from pid file after monitor crash
    def initialize(command = nil)
      @command = command if command
      self.monitored = true
    end

    def loop(&block)
      raise "No block" unless block_given?
      self.command = block
    end

    def spawn
      if @command.is_a? String
        @pid = fork do
          # Doesn't work
          # $0 = 'daemon_from_file'
          exec @command
        end
      elsif @command.is_a? Proc
        @pid = fork do
          # Character limited to 13?
          # $0 = 'daemon_from_proc'
          $DEBUG = false
          $RUNNING = true

          Signal.trap("TERM") { $RUNNING = false }
          Signal.trap("USR1") { $DEBUG = !$DEBUG }

          # exec @command
          while $RUNNING
            @command.call
          end
          puts "Exited loop!"
        end
      else
        raise "What?"
      end

      puts "Forked #{self.name} : #{self.pid}"
      self.started_at = Time.now
      self.spawn_count = self.spawn_count ? self.spawn_count + 1 : 1
      exit_status = ::Process.waitpid2(pid, 0)
      # ::Process.detach(@pid)
      puts "Exited : #{exit_status.inspect}"
      self.pid = nil
      self.started_at = nil
    end

    def kill
      # check if running first
      puts "Killing #{self.name} #{self.pid}"
      ::Process.kill("TERM", self.pid)
    end

    def monitor
      self.monitored = true
    end

    def unmonitor
      self.monitored = false
    end

    def debug
      if running?
        ::Process.kill("USR1", self.pid)
      else
        puts "Not running!"
      end
    end

    def running?
      ::Process.kill(0, self.pid)
      true
    rescue Errno::ESRCH
      false
    end

  end
end
