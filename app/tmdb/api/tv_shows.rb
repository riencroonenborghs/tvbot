module TMDb
  module API
    class TvShows < Request
      def getById id
        response = get "#{API_URL}/tv/#{id}?api_key=#{ENV['THEMOVIEDB_API_TOKEN']}"
        process response
      end
    end
  end
end