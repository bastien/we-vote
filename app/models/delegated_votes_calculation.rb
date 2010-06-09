class DelegatedVotesCalculation
  
  # This method will initialize the table with all the person that have already voted
  #
  def initialize_existing_votes
    Vote.all.each do |vote|
      DelegatedVote.create( :user_id => vote.user_id, 
                            :current_value => vote.value, 
                            :last_value => vote.value, 
                            :last_increment => vote.value )
    end
  end
  
  # Returns the list of all the delegation given to user with the current vote
  #
  def delegatees(delegated_vote)
    Delegation.where('delegations.delegated_id' => delegated_vote.user_id, 
                     'votes.value' => nil).joins("LEFT JOIN votes ON votes.user_id = delegations.delegatee_id")
  end
  
  def delegate_one(delegatee, delegated_vote)
    divider = Delegation.where(:delegatee_id => delegatee.delegatee_id).count
    if target_vote = DelegatedVote.where(:user_id => delegatee.delegatee_id).first
      if target_vote.affected
        target_vote.update_attributes(:affected => true, :current_value => target_vote.current_value + partial_vote(delegated_vote, divider) )
      else
        target_vote.update_attributes(:affected => true, :current_value => target_vote.last_value + partial_vote(delegated_vote, divider) )
      end
    else
      new_vote = DelegatedVote.create(:user_id => delegatee.delegatee_id, :current_value => partial_vote(delegated_vote, divider))
    end
  end
  
  # Looping through all the delegated votes that have changed during the last loop
  #
  def delegate_all
    DelegatedVote.where('ABS(last_increment) > ?', 0.0001).each do |delegated_vote|
      delegatees(delegated_vote).each do |delegatee|
        delegate_one(delegatee, delegated_vote)
      end
    end
  end
  
  # reset the current_value column
  # don't we have a problem there, with the ones that aren't supposed to move anymore
  # trying to store everything on so few colums is problematic, doesn't work
  #
  def prepare_for_next_round
    DelegatedVote.where('affected = ? OR last_affected = ?', true, true).each do |delegated_vote|
      if delegated_vote.last_affected && !delegated_vote.affected
        delegated_vote.last_affected = false
        delegated_vote.last_increment = 0
      end
      if delegated_vote.affected
        delegated_vote.last_affected = true
        delegated_vote.affected = false
        if delegated_vote.last_value.nil?
          delegated_vote.last_increment = delegated_vote.current_value
        else
          delegated_vote.last_increment = delegated_vote.current_value - delegated_vote.last_value
        end
      end
      if delegated_vote.last_increment.abs > 0.0001
        delegated_vote.last_value = delegated_vote.current_value
        delegated_vote.current_value = 0
      end
      delegated_vote.save
    end
  end
  
  def start
    # first round, initialization
    initialize_existing_votes
    
    5.times do
      delegate_all
      prepare_for_next_round
    end
  end
  
  def partial_vote(delegated_vote, partition)
    return 0 if partition == 0
    delegated_vote.last_increment / partition.to_f
  end
  
end