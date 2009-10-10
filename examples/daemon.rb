#! /usr/bin/env ruby

$DEBUG = false
$RUNNING = true

Signal.trap("TERM") { $RUNNING = false }
Signal.trap("USR1") { $DEBUG = !$DEBUG }

while $RUNNING
  begin
    # puts "#{$$}: File doing stuff #{Dir.pwd}"
    puts "#{$$}: Debug mode ON" if $DEBUG
    sleep 2
    raise "file daemon exception!" if rand(30) == 2 # randomly raise exceptions to test monitor
  rescue Interrupt
    puts "CTRL-C caught by file daemon"
    # $RUNNING = false
  end
end

puts "Exiting file daemon"
