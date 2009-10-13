require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Penguin::Process do
  describe "#initialize" do
    it "sets a process to monitored on creation" do
      @process = Penguin::Process.new
      @process.monitored.should be_true
    end

    it "remembers the command to monitor" do
      # command should be nil by default
      @process = Penguin::Process.new
      @process.command.should be_nil

      @process2 = Penguin::Process.new('ls')
      @process2.command.should == 'ls'

      process  = proc { "Ohai!" }
      @process3 = Penguin::Process.new(process)
      @process3.command.should == process
    end
  end

  describe "#monitored?" do
    before(:each) do
      @process = Penguin::Process.new
    end

    it "returns true if process is monitored" do
      @process.monitored = true
      @process.should be_monitored
    end

    it "returns false if process is not monitored" do
      @process.monitored = false
      @process.should_not be_monitored
    end
  end

  describe "#monitor!" do
    before(:each) do
      @process = Penguin::Process.new
    end

    it "should switch unmonitored process to monitored" do
      @process.monitored = false
      lambda {
        @process.monitor!
      }.should change(@process, :monitored?).from(false).to(true)
    end

    it "should keep monitored process monitored" do
      @process.monitored = true
      @process.monitor!
      @process.should be_monitored
    end
  end

  describe "#unmonitor!" do
    before(:each) do
      @process = Penguin::Process.new
    end

    it "should switch monitored process to unmonitored" do
      @process.monitored = true
      lambda {
        @process.unmonitor!
      }.should change(@process, :monitored?).from(true).to(false)
    end

    it "should keep unmonitored process unmonitored" do
      @process.monitored = false
      @process.unmonitor!
      @process.should_not be_monitored
    end
  end

  describe "#running?" do
    before(:each) do
      @process = Penguin::Process.new(test_daemon_path)
    end

    xit "returns true if the daemon is running" do
      @process.spawn
      @process.should be_running
    end

    xit "returns false if daemon is not running" do
      @process.spawn
      kill_daemon_from_path(test_daemon_path)
      @process.should_not be_running
    end
  end
end
