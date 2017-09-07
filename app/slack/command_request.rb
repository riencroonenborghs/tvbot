module Slack
  class CommandRequest < Request
    def initialize(params)
      split_text    = (params[:text] || "").split(" ")
      @slack_user   = Slack::User.from_command params
      @db_user      = ::User.where(uid: @slack_user.id).first || ::User.create!(uid: @slack_user.id, name: @slack_user.name)
      @command      = split_text.shift
      @options      = split_text
      @response_url ||= params[:response_url]
    end

    def process
      return process_help   if help?
      return process_search if search?
      return process_list   if list?
      process_help
    end

    def valid?
      true
    end

  private

    def help?
      @command == "help"
    end

    def process_help
      help = ["`/tv help` helps you along the way"]
      help << "`/tv search tv program` finds out things about *tv program*"
      help << "`/tv list` list all your followed tv programs"
      Slack::Response::ToYouOnly.text help.join("\n")
    end

    def search?
      @command == "search"
    end

    def process_search
      return Slack::Response::ToYouOnly.text "Nothing to search for." unless @options.any?
      begin
        api     = TMDb::API::Search.new @slack_user, @options.join(" ")
        results = api.search
        return Slack::Response::ToYouOnly.text "Nothing found for `#{@options.join(" ")}`." if results.size == 0
        Slack::Response::ToYouOnly.attachments { results }
      rescue => e
        Slack::Response::ToYouOnly.error e
      end
    end   

    def list?
      @command == "list" 
    end
    def process_list
      return Slack::Response::ToYouOnly.text "Your list empty." if @db_user.tv_shows.empty?
      begin
        api = TMDb::API::TvShows.new
        data = @db_user.tv_shows.map do |following|
          # get tv show from TMDb          
          tv_show = api.getById following.tmdb_id
          # start following in db
          hash = {
            fallback:     tv_show[:name],
            color:        "#36a64f", # greenish
            title:        tv_show[:name],
            callback_id:  tv_show[:id],
            fields:       [
              {title: "Rating", value: tv_show[:vote_average]}
            ],
            actions:      [{
              name: "unfollow",
              text: "Unfollow",
              type: "button",
              value: tv_show[:id]
            }]
          }
          hash.update(thumb_url: "#{TMDb::API::Request::IMAGE_PATH}/#{tv_show[:poster_path]}") if tv_show[:poster_path]
          hash
        end
        Slack::Response::ToYouOnly.attachments { data }
      rescue e
        Slack::Response::ToYouOnly.error e
      end
    end


  end
end