require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Penguin::Monitor" do

  it "should add a daemon to be monitored"
  it "should start"
  it "should use ./pids as the default pid directory"
  it "should use the specified pid directory"
  it "should remove the monitor pid file"
  it "should kill all the daemons"
  it "should kill the specified daemon"
  it "should get the pid and port of the running monitor"
  it "should unmonitor the specified daemon"
  it "should monitor the specified daemon"
  it "should toggle debug on the specified daemon"
  it "should process em data"
  it "should monitor all the monitored daemons every x seconds"
  it "should restart dead monitored daemons"
  it "should not restart dead unmonitored daemons"
  it "should display the daemon status"
  it "should clean up before exit"
end
