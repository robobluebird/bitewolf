class Group
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type:String
  field :description, type:String
  field :last_rand, type:String

  has_and_belongs_to_many :users
  embeds_many :lunches
  has_many :invitations

  validates_uniqueness_of :name
end
