module Slack
  class ActionsRequest < Request
    attr_accessor :user
    def initialize(params)
      @payload      = JSON.parse params[:payload] || "{}"
      @actions      = @payload["actions"] || []
      # @user         = Slack::User.new @payload["user"]
      @response_url ||= @payload["response_url"]
    end

    def process
      return process_actions if actions?
    end

    def valid?
      actions?
    end

  private

    def actions?
      @actions.any?
    end

    def process_actions
      begin
        attachments = [].tap do |ret|
          @actions.each do |action|
            ret << process_follow(action)   if action["name"] == "follow"
            ret << process_unfollow(action) if action["name"] == "unfollow"
          end
        end.flatten

        Slack::Response::ToYouOnly.attachments do
          attachments
        end
      rescue => e
        Slack::Response::ToYouOnly.error e
      end
    end

    def process_follow action
      begin
        api     = TMDb::API::TvShows.new
        tv_show = api.getById action["value"]
        {
          fallback:     "You have started following #{tv_show[:name]}.",
          color:        "#36a64f", # greenish
          title:        "You have started following #{tv_show[:name]}.",
          text:         "If new episodes air, you will be notified!"
        }
      rescue e
        Slack::Response::ToYouOnly.error e
      end
    end

    def process_unfollow action
    end
  end
end