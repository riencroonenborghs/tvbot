module TMDb
  module API
    class Request
      API_URL     = "http://api.themoviedb.org/3"
      HEADERS     = {"Accept" => "application/json"}
      OK_RESPONSE = 200
      
      def get url
        ::Unirest.get url, headers: HEADERS
      end

      def process response
        begin
          if response.code == OK_RESPONSE
            process_body response.body
          else
            ::Slack::Response::ToYouOnly.text "Error contacting TMDb"
          end
        rescue
          ::Slack::Response::ToYouOnly.text "Error contacting TMDb"
        end
      end
    end
  end
end