module WeVote
  class DelegationsController < ApplicationController
    
    def index
      @delegations = WeVote::Delegation.where(:delegatee_id => get_user_id)
    end
    
    def new
      @delegation = WeVote::Delegation.new(:delegatee_id => get_user_id)
    end
    
    def create
      @delegation = WeVote::Delegation.new(params[:we_vote_delegation].update(:delegatee_id => get_user_id))
    end
    
    def show
      @delegation = WeVote::Delegation.where(:delegatee_id => get_user_id).find(params[:id])
    end
    
    def destroy
      @delegation = WeVote::Delegation.where(:delegatee_id => get_user_id).find(params[:id])
    end
    
    private
  
    def get_user_id
      current_user.id
    end
    
  end
end