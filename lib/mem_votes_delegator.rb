class MemVotesDelegator
  attr_accessor :new_votes, :votes
  
  MAX_LOOP = 10
  
  def initialize(votes, delegations, proposal_id)
    @proposal_id = proposal_id
    @fixed_votes = votes
    @new_votes = votes
    @delegations = delegations
    @temporary_votes = {}
    @votes = {}
  end
  
  def start!
    i = 0
    while !@new_votes.empty? && i < MAX_LOOP do
      iteration
      i += 1
    end
    DelegatedVote.transaction do
      @votes.each do |user_id, vote|
        create_or_update_delegated_vote(user_id, @proposal_id, vote[:value])
      end
    end
  end
  
  # This method should probbaly be put in DelegatedVote instead
  def create_or_update_delegated_vote(user_id, proposal_id, value)
    if existing_vote = DelegatedVote.where({:user_id => user_id, :proposal_id => proposal_id}).first
      existing_vote.update_attributes(:value => value)
    else
      DelegatedVote.create!(:user_id => user_id, :proposal_id => proposal_id, :value => value)
    end
  end
  
  def user_delegations(user_id)
    @delegations.select{|delegation| delegation[:delegated] == user_id }
  end
  
  def find_existing_vote(delegated)
    existing_vote = @new_votes[delegated]
    existing_vote ||= @votes[delegated]
  end
  
  def set_temporary_vote(delegated_key, increment)
    if @temporary_votes[delegated_key].nil?
      if existing_vote = find_existing_vote(delegated_key)
        @temporary_votes[delegated_key] = { :value => existing_vote[:value] + increment, :increment => increment}
      else
        @temporary_votes[delegated_key] = { :value => increment, :increment => increment}
      end
    else
      @temporary_votes[delegated_key][:value] += increment
      @temporary_votes[delegated_key][:increment] += increment
    end
  end
  
  def iteration
    @new_votes.each do |user_id, vote|
      user_delegations(user_id).each do |delegation|
        delegated_key = delegation[:delegatee]
        unless @fixed_votes[delegated_key] # proper votes can't be influenced
          divider = @delegations.select{|del| del[:delegatee] == delegated_key }.size #TODO store this in a hash
          increment = (vote[:increment].to_f / divider)
          set_temporary_vote(delegated_key, increment)
        end
      end
    end
    @votes.merge! @new_votes
    @new_votes = @temporary_votes
    @temporary_votes = {}
  end
  
  class << self
    
    def votes_hash(proposal_id)
      Vote.where(:proposal_id => proposal_id).inject({}) do |hash, vote|
        hash.merge(vote.user_id => {:value => vote.value, :increment => vote.value})
      end
    end
    
    def delegated_votes_hash(proposal_id)
      DelegatedVote.where(:proposal_id => proposal_id).inject({}) do |hash, vote|
        hash.merge(vote.user_id => {:value => vote.value, :increment => vote.value})
      end
    end
    
    def new_votes_hash(new_votes, delegated_votes, existing_votes)
      new_votes.inject({}) do |hash, vote|
        # previous_vote = existing_votes[vote.user_id]
        # we can't use the existing vote because the value is the same => increment = 0
        previous_vote = delegated_votes[vote.user_id]
        increment = vote.value
        increment = increment - previous_vote[:value] if previous_vote
        hash.merge(vote.user_id => {:value => vote.value, :increment => increment})
      end
    end
    
    def delegations_hash(theme_id, existing_voter_ids=[])
      Delegation.where(["delegatee_id NOT IN (?) AND theme_id = ?", existing_voter_ids, theme_id]).map do |delegation|
        {:delegated => delegation.delegated_id, :delegatee => delegation.delegatee_id}
      end
    end
    
    def start_delegation(proposal_id, theme_id)
      existing_votes = votes_hash(proposal_id)
      mem_votes_delegator = new(existing_votes, delegations_hash(theme_id, existing_votes.keys), proposal_id)
      mem_votes_delegator.start!
    end
    
    def update_delegation(proposal_id, theme_id, new_votes)
      existing_votes = votes_hash(proposal_id)
      mem_votes_delegator = new(existing_votes, delegations_hash(theme_id, existing_votes.keys), proposal_id)
      delegated_votes = delegated_votes_hash(proposal_id)
      mem_votes_delegator.votes =  delegated_votes
      mem_votes_delegator.new_votes = new_votes_hash(new_votes, delegated_votes, existing_votes)
      mem_votes_delegator.start!
    end
    
  end

end