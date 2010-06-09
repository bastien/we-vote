require 'spec_helper'

describe DelegatedVotesCalculation do
  
  describe "the delegation process" do
    
    before(:each) do
      Vote.create!(:user_id => 1, :value => 1)
      Vote.create!(:user_id => 2, :value => 1)
      Delegation.create(:delegatee_id => 3, :delegated_id => 1)
      Delegation.create(:delegatee_id => 3, :delegated_id => 2)
      Delegation.create(:delegatee_id => 4, :delegated_id => 3)
      Delegation.create(:delegatee_id => 2, :delegated_id => 1)
      Delegation.create(:delegatee_id => 1, :delegated_id => 2)
    end
    
    it "should assign a value to all the person who delegated their vote #1" do
      DelegatedVotesCalculation.new.start
      DelegatedVote.count.should == 4
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,1,1]
      DelegatedVote.all.map{|dv| dv.current_value }.should == [1,1,0,0]
    end
        
  end
  
  describe "the delegation process" do
    
    before(:each) do
      Vote.create!(:user_id => 1, :value => 1)
      Vote.create!(:user_id => 2, :value => 1)
      Delegation.create(:delegatee_id => 4, :delegated_id => 1)
      Delegation.create(:delegatee_id => 3, :delegated_id => 2)
      Delegation.create(:delegatee_id => 4, :delegated_id => 3)
      Delegation.create(:delegatee_id => 2, :delegated_id => 1)
      Delegation.create(:delegatee_id => 1, :delegated_id => 2)
    end
    
    it "should assign a value to all the person who delegated their vote #2" do
      DelegatedVotesCalculation.new.start
      DelegatedVote.count.should == 4
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,1,1]
      DelegatedVote.all.map{|dv| dv.current_value }.should == [1,1,0,0]
    end
        
  end
  
  describe "the delegation process" do
    
    before(:each) do
      Vote.create!(:user_id => 1, :value => 1)
      Vote.create!(:user_id => 2, :value => 1)
      Delegation.create(:delegatee_id => 3, :delegated_id => 2)
      Delegation.create(:delegatee_id => 4, :delegated_id => 1)
      Delegation.create(:delegatee_id => 4, :delegated_id => 3)
      Delegation.create(:delegatee_id => 5, :delegated_id => 1)
      Delegation.create(:delegatee_id => 5, :delegated_id => 4)
      Delegation.create(:delegatee_id => 2, :delegated_id => 1)
      Delegation.create(:delegatee_id => 1, :delegated_id => 2)
    end
    
    it "should assign a value to all the person who delegated their vote #3" do
      DelegatedVotesCalculation.new.start
      DelegatedVote.count.should == 5
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,1,1,1]
      DelegatedVote.all.map{|dv| dv.current_value }.should == [1,1,0,0,0]
    end
        
  end
  
end