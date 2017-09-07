module Slack
  class User
    attr_accessor :id, :name
    
    def self.from_command params
      new(id: params["user_id"], name: params["user_name"])
    end
    def self.from_actions payload
      new(id: payload.fetch("user", {}).fetch("id", nil), name: payload.fetch("user", {}).fetch("name", nil))
    end

    def initialize(id, name)
      @id = id
      @name = name
    end
  end
end