module WeVote
  class VotesController < ApplicationController
    # the authentification has to be dealed with in the main system
    unloadable
    
    def create
      @vote = WeVote::Vote.new(params[:we_vote_vote].update(:user_id => get_user_id))
      if @vote.save
        redirect_to redirection_path, :notice => "Your vote has been registered"
      else
        redirect_to redirection_path, :alert => "There was a problem registering your vote, please try again"
      end
    end

    def update
      @vote = WeVote::Vote.find(params[:id])
      if @vote.update_attributes(params[:we_vote_vote])
        redirect_to redirection_path, :notice => "Your vote has been registered"
      else
        redirect_to redirection_path, :alert => "There was a problem updating your vote, please try again"
      end
    end
  
    private
  
    def get_user_id
      current_user.id
    end
  
    def redirection_path
      "/"
    end
  
  end
end