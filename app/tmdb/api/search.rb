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
          hash = {
            fallback:     result["name"],
            color:        "#36a64f", # greenish
            title:        result["name"],
            text:         result["overview"],
            callback_id:  result["id"],
            fields:       [
              {title: "Rating", value: result["vote_average"]}
            ],
            actions:      [
              {
                  name: "follow",
                  text: "Follow #{result["name"]}",
                  type: "button",
                  value: result["id"]
              }
            ]
          }
          hash.update(thumb_url: "#{IMAGE_PATH}/#{result["poster_path"]}") if result["poster_path"]
          hash
        end
      end
    end
  end
end