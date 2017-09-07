class TvShow
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :tmdb_id, type: String
  field :name, type: String

  embedded_in :user
end