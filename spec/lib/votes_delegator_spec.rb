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
      VotesDelegator.new(30).start
      DelegatedVote.count.should == 5
      DelegatedVote.all.map{|dv| dv.last_value }.should == [-1,1,0,-0.5,1]
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
      VotesDelegator.new(30).start
      new_vote = Vote.create!(:user_id => 3, :value => -1, :proposal_id => 30)
      VotesDelegator.new(30, [new_vote.id]).start
      DelegatedVote.all.map{|dv| dv.last_value }.should == [1,1,0,0.5,-1]
    end
    
  end
  
  describe "initialization of the delegation" do
    
    describe "first initialization" do
      before(:each) do
        Vote.create!(:user_id => 1, :value => 1, :proposal_id => 30)
        Vote.create!(:user_id => 2, :value => 1, :proposal_id => 30)
        Vote.create!(:user_id => 1, :value => 1, :proposal_id => 31)
      end
      it "should assign a delegated vote for each of the existing votes" do
        init_count = DelegatedVote.count
        VotesDelegator.new(30)
        DelegatedVote.count.should == init_count + 2
        DelegatedVote.all.map{|dv| dv.user_id }.should == [1, 2]
      end
    end
    
    describe "when a vote changes" do
      before(:each) do
        @first_vote = Vote.create!(:user_id => 1, :value => 1, :proposal_id => 30)
        @second_vote =Vote.create!(:user_id => 2, :value => 1, :proposal_id => 30)
        @delegated_vote = DelegatedVote.create!(:user_id => 1, :proposal_id => 30, :last_value => 1)
      end
       it "should update the vote that has changed" do
          @first_vote.update_attribute(:value, -1)
          init_count = DelegatedVote.count
          VotesDelegator.new(30, [@first_vote.id])
          DelegatedVote.count.should == init_count
          @delegated_vote.reload
          @delegated_vote.current_value.should == -1
          @delegated_vote.last_increment.should == -2
          @delegated_vote.last_value.should == -1
          DelegatedVote.all.map{|dv| dv.user_id }.should == [1]
        end
        
        it "should create the vote if it didn't exist" do
            init_count = DelegatedVote.count
            VotesDelegator.new(30, [@second_vote.id])
            DelegatedVote.count.should == init_count + 1
            new_vote = DelegatedVote.last
            new_vote.current_value.should == 1
            new_vote.last_increment.should == 1
            new_vote.last_value.should == 1
            DelegatedVote.all.map{|dv| dv.user_id }.should == [1, 2]
          end
    end
    
  end
  
end