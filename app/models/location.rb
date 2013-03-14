class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  field :restaurant, type:String
  field :style, type:String
  field :upvotes, type:Array
  field :downvotes, type:Array
  field :suggester_id, type:String

  embedded_in :lunch
end
