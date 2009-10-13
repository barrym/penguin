#!/usr/bin/env ruby

$DEBUG   = false
$RUNNING = true

Signal.trap("TERM") { $RUNNING = false }
Signal.trap("USR1") { $DEBUG = !$DEBUG }

while $RUNNING
  sleep 2
end
