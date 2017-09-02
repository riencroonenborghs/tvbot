require "sinatra"
require "sinatra/json"
require "unirest"

require_relative "app/slack/request"
require_relative "app/slack/user"
require_relative "app/slack/response"
require_relative "app/slack/authorizer"

require_relative "app/tmdb/api/request"
require_relative "app/tmdb/api/search"

use Slack::Authorizer

post "/" do
  slack_request = Slack::Request.new params
  json slack_request.process
end

