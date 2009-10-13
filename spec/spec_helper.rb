$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'penguin'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|

end

def test_daemon_path
  File.expand_path(File.join(File.dirname(__FILE__), 'daemons', 'daemon.rb'))
end

def kill_daemon_from_path(path)
  pid = `ps x | grep -v grep | grep #{path}`.chomp.split(' ').first.to_i
  ::Process.kill(9, pid)
  pid
end
