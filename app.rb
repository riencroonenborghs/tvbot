require "sinatra"
require "sinatra/json"
require "unirest"

require_relative "app/slack/request"
require_relative "app/slack/user"
require_relative "app/slack/response"
require_relative "app/slack/authorizer"

require_relative "app/tmdb/api/request"
require_relative "app/tmdb/api/search"
require_relative "app/tmdb/api/tv_shows"

use Slack::Authorizer

post "/" do
  slack_request = Slack::Request.new params
  response = slack_request.process
  Slack::Response.post slack_request.repsonse_url, response
end

