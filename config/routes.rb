class TvBot < Sinatra::Base
  post "/" do
    slack_request = Slack::Request.new params
    response      = slack_request.process
    Slack::Response.post slack_request.response_url, response.to_json
  end  
end