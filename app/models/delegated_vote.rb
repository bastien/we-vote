class DelegatedVote < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :user
end
