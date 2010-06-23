class Delegation < ActiveRecord::Base
  belongs_to :delegatee, :class_name => "User"
  belongs_to :delegated, :class_name => "User"
end
