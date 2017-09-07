module Slack
  class ActionsRequest < Request
    attr_accessor :user
    def initialize(params)
      @payload      = JSON.parse params[:payload] || "{}"
      @actions      = @payload["actions"] || []
      slack_user    = Slack::User.from_actions @payload
      @db_user      = ::User.where(uid: slack_user.id).first || ::User.create!(uid: slack_user.id, name: slack_user.name)
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
        # get tv show from TMDb
        api     = TMDb::API::TvShows.new
        tv_show = api.getById action["value"]
        # start following in db
        @db_user.tv_shows.create!(tmdb_id: tv_show[:id], name: tv_show[:name]) unless @db_user.tv_shows.where(id: tv_show[:id]).exists?
        # respond
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