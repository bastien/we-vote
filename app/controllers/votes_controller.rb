class VotesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    @proposal = Proposal.find(params[:proposal_id])
    @vote = @proposal.votes.new(params[:vote].update(:user => current_user))
    if @vote.save
      redirect_to proposal_path(@proposal), :notice => "Your vote has been registered"
    else
      render "proposals/show", :alert => "Your vote didn't work, please try again"
    end
  end
  
  def update
    @proposal = Proposal.find(params[:proposal_id])
    @vote = @proposal.votes.find(params[:id])
    if @vote.update_attributes(params[:vote])
      redirect_to proposal_path(@proposal), :notice => "Your vote has been registered"
    else
      render "proposals/show", :alert => "Your vote wasn't modified, please try again"
    end
  end

end
