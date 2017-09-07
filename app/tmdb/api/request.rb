module TMDb
  module API
    class Request
      API_URL     = "http://api.themoviedb.org/3"
      IMAGE_PATH  = "https://image.tmdb.org/t/p/w185"
      HEADERS     = {"Accept" => "application/json"}
      OK_RESPONSE = 200

      def self.symbolize_keys(hash)
        hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      end
      
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

      def process_body body
        self.class.symbolize_keys body
      end
    end
  end
end