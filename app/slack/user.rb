module Slack
  class User
    attr_accessor :id, :name
    
    def self.from_command params
      new params["user_id"], params["user_name"]
    end
    def self.from_actions payload
      new payload.fetch("user", {}).fetch("id", nil), payload.fetch("user", {}).fetch("name", nil)
    end

    def initialize(id, name)
      @id = id
      @name = name
    end
  end
end