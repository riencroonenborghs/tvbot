module TMDb
  module API
    class TvShows < Request
      def get id
        response = get "#{API_URL}/tv/#{id}?api_key=#{ENV['THEMOVIEDB_API_TOKEN']}"
        process response
      end

    private

      def process_body body
        {id: body["id"], name: body["name"]}
      end
    end
  end
end