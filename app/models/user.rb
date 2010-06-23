class User < ActiveRecord::Base
  has_many :proposals, :foreign_key => "author_id"
  has_many :votes
  has_many :delegated_votes
  has_many :delegations, :foreign_key => "delegatee_id"
  has_many :delegates, :through => :delegations, :source => "delegated"
  has_many :deputations, :class_name => "Delegation", :foreign_key => "delegated_id"
  has_many :delegatees, :through => :deputations
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
end
