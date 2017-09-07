module TMDb
  module API
    class TvShows < Request
      def getById id
        puts "TMDb::API::TvShows.get #{id}"
        response = get "#{API_URL}/tv/#{id}?api_key=#{ENV['THEMOVIEDB_API_TOKEN']}"
        process response
      end

    private

      def process_body body
        # symbolize all keys
        body.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      end
    end
  end
end