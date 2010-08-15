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
      if @delegation.save
        flash[:notice] = "Delegation assigned"
      else
        flash[:error] = "Failed to assign delegation"
      end
      redirect_to params[:redirect_to] || '/'
    end
    
    def show
      @delegation = WeVote::Delegation.where(:delegatee_id => get_user_id).find(params[:id])
    end
    
    def destroy
      @delegation = WeVote::Delegation.where(:delegatee_id => get_user_id).find(params[:id])
      if @delegation.destroy
        flash[:notice] = "Delegation removed"
      else
        flash[:error] = "Failed to remove delegation"
      end
      redirect_to params[:redirect_to] || '/'
    end
    
    private
  
    def get_user_id
      current_user.id
    end
    
  end
end