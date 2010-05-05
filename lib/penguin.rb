$:.unshift File.dirname(__FILE__)

# standard
require 'fileutils'
require 'socket'

# dependencies - remember to add/remove these to the Rakefile
require 'eventmachine'
require 'json'
require 'sinatra/base'

# client
require 'timeout'

# internal
require 'penguin/client'
require 'penguin/daemon'
require 'penguin/process'
require 'penguin/monitor'
require 'penguin/gui'

module Penguin

  # rename
  def self.config(&block)
    raise "No block" unless block_given?
    c = Config.new
    yield(c)
  end

  class Config
    def daemon(&block)
      raise "No block" unless block_given?
      d = Process.new
      yield(d)
      Monitor.add_daemon(d)
    end
  end

end
