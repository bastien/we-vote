class Proposal < ActiveRecord::Base
  belongs_to :author, :class_name => "User"
  has_many :votes
  has_many :delegated_votes
  
  def user_vote(user)
    @user_vote ||= UserVote.new(self, user)
  end
  
  def total_score
    voter_ids = votes.map(&:id)
    (votes.map(&:value) + delegated_votes.where("user_id NOT IN (?)", voter_ids).map(&:last_value)).compact.average
  end
  
  def total_votes_count
    direct_votes_count + delegated_votes.count
  end
  
  def direct_votes_count
    votes.count
  end
  
  def response_rate
    direct_votes_count / User.count
  end
  
end
