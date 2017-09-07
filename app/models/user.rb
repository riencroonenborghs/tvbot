class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :uid, type: String
  field :name, type: String

  embeds_many :tv_shows
end