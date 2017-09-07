require "sinatra/base"
require "mongoid"

class TvBot < Sinatra::Base
  configure :development do
    set :environment, :development
    Mongoid.load!(File.expand_path(File.join("config", "mongoid.yml")))
  end

  configure :test do
    set :environment, :test
    disable :run, :dump_errors, :logging
    Mongoid.load!(File.expand_path(File.join("config", "mongoid.yml")))
  end

  configure :production do
    set :environment, :production
    Mongoid.load!(File.expand_path(File.join("config", "mongoid.yml")))
  end
end