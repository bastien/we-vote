class Proposal < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  has_many :votes
  has_many :delegated_votes
  
  def total_score
    (votes.map(&:value) + delegated_votes.map(&:last_value)).compact.average
  end
  
  def total_votes_count
    votes.count + delegated_votes.count
  end
  
end
