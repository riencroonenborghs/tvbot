module Slack
  class Response
    class InChannel
      IN_CHANNEL = {response_type: "in_channel"}
      def self.text text
        IN_CHANNEL.update(text: text)
      end
      def self.image_url image_url
        IN_CHANNEL.update(attachments: [image_url: image_url])
      end
    end
    
    class ToYouOnly
      def self.text text
        {text: text}
      end
      def self.attachments &block
        ret = {
          attachments: yield 
        }
      end
      def self.error message
        {attachments: [
          {text: message, color: "#ff0000", pretext: "An error occurred"}
        ]}
      end
    end

    class Direct
      SLACK_API_URL = "https://slack.com/api"

      def initialize(uid)
        @uid = uid
      end

      def send_message &block
        im_open
        data = {
          channel: @channel,
          attachments: yield.to_json
        }
        result = post "chat.postMessage", data
        raise "could not send_message" unless result["ok"]
      end

      def done
        im_close
      end
    private
      def im_open
        result = post "im.open", {user: @uid, return_im: false}
        raise "cannot im.open" unless result["ok"]
        @channel = result["channel"]["id"]
      end
      def im_close
        result = post "im.close", {channel: @channel}
        raise "cannot im.close" unless result["ok"]
      end
      def post(api_call, data)
        url   = "#{SLACK_API_URL}/#{api_call}"
        data = data.update(token: ENV["SLACK_OAUTH_TOKEN"])
        response = ::Unirest.post url, headers: {"Accept" => "application/x-www-form-urlencoded"}, parameters: data
        response.body
      end
    end

    def self.post url, data
      ::Unirest.post url, headers: {"Accept" => "application/json"}, parameters: data
    end
  end
end