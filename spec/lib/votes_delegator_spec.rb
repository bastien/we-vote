require 'spec_helper'

describe VotesDelegator do
  
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
      VotesDelegator.new(30).start
      DelegatedVote.count.should == 4
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,1,1]
      DelegatedVote.all.map{|dv| dv.current_value }.should == [1,1,0,0]
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
      VotesDelegator.new(30).start
      DelegatedVote.count.should == 4
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,1,1]
      DelegatedVote.all.map{|dv| dv.current_value }.should == [1,1,0,0]
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
      VotesDelegator.new(30).start
      DelegatedVote.count.should == 5
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,1,1,1]
      DelegatedVote.all.map{|dv| dv.current_value }.should == [1,1,0,0,0]
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
      VotesDelegator.new(31).start
      DelegatedVote.count.should == 0
    end
        
  end
  
end