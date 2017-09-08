$:.unshift File.join(__FILE__, "../config")

require "mongoid"
require "unirest"
require "bundler/setup"
require "tvbot"
require "rufus-scheduler"

require_relative "app/slack/authorizer"
require_relative "app/slack/request"
require_relative "app/slack/command_request"
require_relative "app/slack/actions_request"
require_relative "app/slack/response"
require_relative "app/slack/user"

require_relative "app/tmdb/api/request"
require_relative "app/tmdb/api/search"
require_relative "app/tmdb/api/tv_shows"
require_relative "app/tmdb/api/airing_today"

require_relative "app/models/user"
require_relative "app/models/tv_show"

require_relative "app/airing_notifications"

scheduler = Rufus::Scheduler.new
scheduler.every "2m" do
  AiringNotifications.new.check!
end
scheduler.join
