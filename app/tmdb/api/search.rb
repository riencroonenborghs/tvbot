module TMDb
  module API
    class Search < Request
      def initialize query
        @query = query
      end

      def search
        response = get "#{API_URL}/search/tv?api_key=#{ENV['THEMOVIEDB_API_TOKEN']}&query=#{@query}"
        process response
      end

    private

      def process_body body
        body["results"].map do |result|
          "#{result["name"]} (#{result['vote_average']}*)"
        end
      end
    end
  end
end