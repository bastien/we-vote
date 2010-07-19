class UserVote
  attr_accessor :value, :type
  
  def initialize(proposal, user)
    vote = proposal.votes.where(:user_id => user.id).first
    if vote.present?
      self.value = vote.value
      self.type = "direct"
    else
      if vote = proposal.delegated_votes.where(:user_id => user.id).first
        self.value = vote.last_value
        self.type = "delegated"
      end
    end
  end
  
end