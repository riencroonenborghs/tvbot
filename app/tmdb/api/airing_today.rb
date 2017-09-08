module TMDb
  module API
    class AiringToday < Request
      def getAll
        # airing_today API call is paged
        # - get first page and keep results
        #   and get total_pages
        # - get all other pages and keep results
        first_result    = getPage(1)
        all_aired_today = first_result[:results]
        (2..first_result[:total_pages]).each do |page|
          result = getPage(page)
          all_aired_today += result[:results]
        end

        # index by tv show ID
        {}.tap do |ret|
          all_aired_today.each do |tv_show|
            ret[tv_show[:id].to_s] = tv_show
          end
        end
      end

      def getPage(page)
        response = get "#{API_URL}/tv/airing_today?api_key=#{ENV['THEMOVIEDB_API_TOKEN']}&page=#{page}"
        process response
      end
    end
  end
end

