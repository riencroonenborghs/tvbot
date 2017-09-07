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
        hash = self.class.symbolize_keys body
        return hash[:results]
      end
    end
  end
end