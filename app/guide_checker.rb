class GuideChecker
  def check!
    begin
      # get all aired tv programs
      api             = TMDb::API::AiringToday.new
      all_aired_today = api.getAll

      # check against database and keep list of who to notify for what tv shows
      to_notify = {}
      all_tv_shows.each do |tmdb_id, data|
        if aired_today = all_aired_today[tmdb_id]
          data.each do |item|
            to_notify[item[:user]] ||= []
            to_notify[item[:user]] << {tmdb_id: tmdb_id, name: data[0][:name], poster_path: aired_today[:poster_path]}
          end
        end
      end

      # notify them
      to_notify.each do |user, tv_shows|
        response = ::Slack::Response::Direct.new user[:uid]
        response.send_message do
          index = 0
          tv_shows.map do |tv_show|
            index += 1
            hash = {
              text: tv_show[:name],
              fallback: tv_show[:name],
              color: "#367da6" # blue-ish
            }
            hash.update(thumb_url: "#{TMDb::API::Request::IMAGE_PATH}/#{tv_show[:poster_path]}") if tv_show[:poster_path]
            hash.update(pretext: "Hello! Some tv programs aired today!") if index == 1
            hash
          end
        end
        response.done
      end
    rescue e
      puts "ERROR: #{e.message}"
    end
  end

private

  def all_tv_shows
    {}.tap do |ret|
      ::User.all.each do |user|
        user.tv_shows.each do |tv_show|
          ret[tv_show.tmdb_id] ||= []
          data = {user: {uid: user.uid, name: user.name}, name: tv_show.name}
          ret[tv_show.tmdb_id] << data unless ret[tv_show.tmdb_id].include? data
        end
      end
    end
  end
end