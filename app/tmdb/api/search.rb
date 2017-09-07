module TMDb
  module API
    class Search < Request
      def initialize slack_user, query
        @db_user  = User.where(uid: slack_user.id).first || User.create!(uid: slack_user.id, name: slack_user.name)
        @query    = query
      end

      def search
        response = get "#{API_URL}/search/tv?api_key=#{ENV['THEMOVIEDB_API_TOKEN']}&query=#{@query}"
        process response
      end

    private

      def process_body body
        body["results"].map do |result|
          is_following = @db_user.tv_shows.where(tmdb_id: result["id"]).exists?
          hash = {
            fallback:     result["name"],
            color:        "#36a64f", # greenish
            title:        result["name"],
            text:         result["overview"],
            callback_id:  result["id"],
            fields:       [
              {title: "Rating", value: result["vote_average"]}
            ],
            actions:      []
          }
          if is_following
            hash[:actions] << {
              name: "unfollow",
              text: "Unfollow",
              type: "button",
              value: result["id"]
            }
          else
            hash[:actions] << {
              name: "follow",
              text: "Follow",
              type: "button",
              value: result["id"]
            }
          end
          hash.update(thumb_url: "#{IMAGE_PATH}/#{result["poster_path"]}") if result["poster_path"]
          hash
        end
      end
    end
  end
end