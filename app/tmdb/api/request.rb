module TMDb
  module API
    class Request
      API_URL     = "http://api.themoviedb.org/3"
      IMAGE_PATH  = "https://image.tmdb.org/t/p/w185"
      HEADERS     = {"Accept" => "application/json"}
      OK_RESPONSE = 200
      
      def get url
        ::Unirest.get url, headers: HEADERS
      end

    private

      def process response
        if response.code == OK_RESPONSE
          process_body response.body
        else
          raise "Error contacting TMDb"
        end
      end

      def process_body
        raise "implement me"
      end
    end
  end
end