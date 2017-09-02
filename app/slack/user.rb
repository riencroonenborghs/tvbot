module Slack
  class User
    attr_accessor :name, :id

    def initialize id, name
      @name = name
      @id = id
    end
  end
end