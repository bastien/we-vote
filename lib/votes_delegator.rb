class VotesDelegator
  
  MAX_LOOP = 10
  
  def initialize(proposal_id, changed_vote_ids=[], theme_id=nil)
    @theme_id = theme_id # for instance : {:theme_id => 3}
    @proposal_id = proposal_id
    if changed_vote_ids.empty?
      initialize_existing_votes
    else
      initialize_changed_votes(changed_vote_ids)
    end
  end
  
  def extra_delegation_params
    return {} if @theme_id.blank?
    {'delegations.theme_id' => @theme_id}
  end
  
  def initialize_changed_votes(changed_vote_ids)
    Vote.where("proposal_id = ? AND id IN (?)", @proposal_id, changed_vote_ids).each do |vote|
      if delegated_vote = DelegatedVote.where(:user_id => vote.user_id, :proposal_id => @proposal_id).first
        delegated_vote.current_value = vote.value
        delegated_vote.last_increment = vote.value - delegated_vote.last_value
        delegated_vote.last_value = vote.value
      else
        delegated_vote = DelegatedVote.new(:proposal_id => @proposal_id, 
                          :user_id => vote.user_id,
                          :last_value => vote.value,
                          :last_increment => vote.value,
                          :current_value => vote.value)
      end
      delegated_vote.affected = true
      delegated_vote.save
    end
  end
  
  # This method will initialize the table with all the person that have already voted
  #
  def initialize_existing_votes
    initialize_changed_votes(Vote.where(:proposal_id => @proposal_id).map(&:id))
    # Vote.where(:proposal_id => @proposal_id).each do |vote|
    #       DelegatedVote.create( :user_id => vote.user_id, 
    #                             :current_value => vote.value, 
    #                             :last_value => vote.value,
    #                             :proposal_id => @proposal_id,
    #                             :last_increment => vote.value )
    #     end
  end
  
  # Returns the list of all the delegation given to user with the current vote
  #
  def delegatees(delegated_vote)
    Delegation.where('delegations.delegated_id' => delegated_vote.user_id, 
                     'votes.value' => nil).where(extra_delegation_params).joins("LEFT JOIN votes ON votes.user_id = delegations.delegatee_id")
  end
  
  def delegate_one(delegatee, delegated_vote)
    divider = Delegation.where(:delegatee_id => delegatee.delegatee_id).where(extra_delegation_params).count
    if target_vote = DelegatedVote.where(:user_id => delegatee.delegatee_id, :proposal_id => @proposal_id).first
      if target_vote.affected
        target_vote.update_attributes(:affected => true, :current_value => target_vote.current_value + partial_vote(delegated_vote, divider) )
      else
        target_vote.update_attributes(:affected => true, :current_value => target_vote.last_value + partial_vote(delegated_vote, divider) )
      end
    else
      new_vote = DelegatedVote.create(:proposal_id => @proposal_id, :user_id => delegatee.delegatee_id, :current_value => partial_vote(delegated_vote, divider))
    end
  end
  
  # Looping through all the delegated votes that have changed during the last loop
  #
  def delegate_all
    delegating = DelegatedVote.where('ABS(last_increment) > ? AND proposal_id = ?', 0.0001, @proposal_id).each do |delegated_vote|
      delegatees(delegated_vote).each do |delegatee|
        delegate_one(delegatee, delegated_vote)
      end
    end
    delegating.size > 0 
  end
  
  # reset the current_value column
  # don't we have a problem there, with the ones that aren't supposed to move anymore
  # trying to store everything on so few colums is problematic, doesn't work
  #
  def prepare_for_next_round
    DelegatedVote.where('affected = ? OR last_affected = ? AND proposal_id = ?', true, true, @proposal_id).each do |delegated_vote|
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
    i = 0
    continue = true
    MAX_LOOP
    while continue && i < MAX_LOOP do
      i += 1
      if continue = delegate_all
        prepare_for_next_round
      end
    end
    # reset_last_increment
  end
  
  def reset_last_increment
    DelegatedVote.where('last_increment != 0 AND proposal_id = ?', @proposal_id).each do |delegated_vote|
      delegated_vote.update_attribute(:last_increment, 0)
    end
  end
  
  def partial_vote(delegated_vote, partition)
    return 0 if partition == 0
    delegated_vote.last_increment / partition.to_f
  end
  
end