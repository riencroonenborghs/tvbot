$:.unshift File.join(__FILE__, "../config")

require "sinatra/base"
require "mongoid"
require "unirest"
require "bundler/setup"
require "tvbot"
require "routes"

require_relative "app/slack/request"
require_relative "app/slack/user"
require_relative "app/slack/response"
require_relative "app/slack/authorizer"

require_relative "app/tmdb/api/request"
require_relative "app/tmdb/api/search"
require_relative "app/tmdb/api/tv_shows"

require_relative "app/models/user"
require_relative "app/models/tv_show"

class TvBot < Sinatra::Base
  use Slack::Authorizer
  set :app_file, __FILE__
end