require 'spec_helper'

describe MemVotesDelegator do
  
  describe "the delegation process" do
    
    before(:each) do
      Vote.create!(:user_id => 1, :value => 1, :proposal_id => 30)
      Vote.create!(:user_id => 2, :value => 1, :proposal_id => 30)
      Delegation.create(:delegatee_id => 3, :delegated_id => 1)
      Delegation.create(:delegatee_id => 3, :delegated_id => 2)
      Delegation.create(:delegatee_id => 4, :delegated_id => 3)
      Delegation.create(:delegatee_id => 2, :delegated_id => 1)
      Delegation.create(:delegatee_id => 1, :delegated_id => 2)
    end
    
    it "should assign a value to all the person who delegated their vote #1" do
      init_count = DelegatedVote.count
      MemVotesDelegator.start_delegation(30, nil)
      DelegatedVote.count.should == init_count + 4
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,1,1]
    end
        
  end
  
  describe "the delegation process" do
    
    before(:each) do
      Vote.create!(:user_id => 1, :value => 1, :proposal_id => 30)
      Vote.create!(:user_id => 2, :value => 1, :proposal_id => 30)
      Delegation.create(:delegatee_id => 4, :delegated_id => 1)
      Delegation.create(:delegatee_id => 3, :delegated_id => 2)
      Delegation.create(:delegatee_id => 4, :delegated_id => 3)
      Delegation.create(:delegatee_id => 2, :delegated_id => 1)
      Delegation.create(:delegatee_id => 1, :delegated_id => 2)
    end
    
    it "should assign a value to all the person who delegated their vote #2" do
      MemVotesDelegator.start_delegation(30, nil)
      DelegatedVote.count.should == 4
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,1,1]
    end
        
  end
  
  describe "the delegation process" do
    
    before(:each) do
      Vote.create!(:user_id => 1, :value => 1, :proposal_id => 30)
      Vote.create!(:user_id => 2, :value => 1, :proposal_id => 30)
      Delegation.create(:delegatee_id => 3, :delegated_id => 2)
      Delegation.create(:delegatee_id => 4, :delegated_id => 1)
      Delegation.create(:delegatee_id => 4, :delegated_id => 3)
      Delegation.create(:delegatee_id => 5, :delegated_id => 1)
      Delegation.create(:delegatee_id => 5, :delegated_id => 4)
      Delegation.create(:delegatee_id => 2, :delegated_id => 1)
      Delegation.create(:delegatee_id => 1, :delegated_id => 2)
    end
    
    it "should assign a value to all the person who delegated their vote #3" do
      MemVotesDelegator.start_delegation(30, nil)
      DelegatedVote.count.should == 5
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,1,1,1]
    end
        
  end
  
  describe "the delegation process" do
    
    before(:each) do
      Vote.create!(:user_id => 1, :value => -1, :proposal_id => 30)
      Vote.create!(:user_id => 2, :value => 1, :proposal_id => 30)
      Delegation.create(:delegatee_id => 3, :delegated_id => 2)
      Delegation.create(:delegatee_id => 4, :delegated_id => 1)
      Delegation.create(:delegatee_id => 4, :delegated_id => 3)
      Delegation.create(:delegatee_id => 5, :delegated_id => 1)
      Delegation.create(:delegatee_id => 5, :delegated_id => 4)
      Delegation.create(:delegatee_id => 2, :delegated_id => 1)
      Delegation.create(:delegatee_id => 1, :delegated_id => 2)
    end
    
    it "should also work when there are negative values" do
      MemVotesDelegator.start_delegation(30, nil)
      DelegatedVote.count.should == 5
      DelegatedVote.all.inject({}){|hash, dv| hash[dv.user_id] = dv.last_value; hash }.should == {5=>-0.5, 1=>-1.0, 2=>1.0, 3=>1.0, 4=>0.0}
    end
        
  end
  
  describe "the delegation process" do
    
    before(:each) do
      Vote.create!(:user_id => 1, :value => 1, :proposal_id => 30)
      Vote.create!(:user_id => 2, :value => 1, :proposal_id => 30)
      Delegation.create(:delegatee_id => 3, :delegated_id => 1)
      Delegation.create(:delegatee_id => 3, :delegated_id => 2)
      Delegation.create(:delegatee_id => 4, :delegated_id => 3)
      Delegation.create(:delegatee_id => 2, :delegated_id => 1)
      Delegation.create(:delegatee_id => 1, :delegated_id => 2)
    end
    
    it "should not assign any value since we're asking for a different proposal" do
      MemVotesDelegator.start_delegation(31, nil)
      DelegatedVote.count.should == 0
    end
        
  end
  
  describe "when a vote changes" do
    
    before(:each) do
      Vote.create!(:user_id => 1, :value => 1, :proposal_id => 30)
      Vote.create!(:user_id => 2, :value => 1, :proposal_id => 30)
      Delegation.create(:delegatee_id => 3, :delegated_id => 2)
      Delegation.create(:delegatee_id => 4, :delegated_id => 1)
      Delegation.create(:delegatee_id => 4, :delegated_id => 3)
      Delegation.create(:delegatee_id => 5, :delegated_id => 1)
      Delegation.create(:delegatee_id => 5, :delegated_id => 4)
      Delegation.create(:delegatee_id => 2, :delegated_id => 1)
      Delegation.create(:delegatee_id => 1, :delegated_id => 2)
    end
    
    it "should assign a new value to all the person who delegated their vote" do
      pending
      MemVotesDelegator.start_delegation(30, nil)
      new_vote = Vote.create!(:user_id => 3, :value => -1, :proposal_id => 30)
      MemVotesDelegator.start_delegation(30, nil)
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,0,0.5,-1]
    end
    
  end
  
end