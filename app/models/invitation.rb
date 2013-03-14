class Invitation
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type:String
  field :name, type:String
  field :email, type:String
  field :code, type:String
  field :inviter, type:String

  belongs_to :group
  belongs_to :user
end
