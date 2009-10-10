#! /usr/bin/env ruby
require 'rubygems'
require '../lib/penguin'

Penguin.config do |c|

  3.times do |n|
    c.daemon do |d|
      d.name = "File Daemon #{n}"
      d.command = "./daemon.rb"
    end
  end

  c.daemon do |d|
    d.name = "Fileless Daemon"
    d.loop do
      # puts "#{$$}: Proc doing stuff"
      puts "#{$$}: Debug mode ON" if $DEBUG
      sleep 2
      raise "proc daemon exception!" if rand(30) == 2
    end
  end


end

Penguin::Monitor.start
