module Penguin
  class GUI
    def self.start(port = 9090)
      App.run! :host => 'localhost', :port => port
    end
  end

  class App < Sinatra::Base

    set :views, File.dirname(__FILE__) + '/views'

    get '/' do
      c = Penguin::Client.new
      @status  = c.status
      @daemons = c.daemons
      erb :index
    end

    post "/restart/:id" do |daemon_id|
      c = Penguin::Client.new
      c.restart(daemon_id)
      redirect '/'
    end

    post "/start/:id" do |daemon_id|
      c = Penguin::Client.new
      c.start(daemon_id)
      redirect '/'
    end

    post "/stop/:id" do |daemon_id|
      c = Penguin::Client.new
      c.stop(daemon_id)
      redirect '/'
    end

  end
end
