class ProposalsController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :index]
  
  def index
    @proposals = Proposal.all
  end
  
  def show
    @proposal = Proposal.find(params[:id])
    @vote = find_vote_for_user
  end
  
  def edit
    @proposal = Proposal.find(params[:id])
  end
  
  def update
    @proposal = Proposal.find(params[:id])
    if @proposal.update_attributes(params[:proposal])
      redirect_to proposal_path(@proposal), :notice => "Proposal succesfully saved"
    else
      render :edit, :alert => "You're proposal couldn't be saved"
    end
  end
  
  def new
    @proposal = current_user.proposals.new()
  end
  
  def create
    @proposal = Proposal.new(params[:proposal])
    if @proposal.save
      redirect_to proposals_path, :notice => "Proposal succesfully created"
    else
      render :new, :alert => "An error occured when trying to save your proposal"
    end
  end
  
  def destroy
    @proposal = Proposal.destroy(params[:id])
    redirect_to proposals_path, :notice => "Proposal '#{@proposal.title}' succesfully deleted"
  end

  protected
  
  def find_vote_for_user
    vote = @proposal.votes.find_by_user_id(current_user.id)
    if vote.nil?
      vote = @proposal.votes.new
      @delegated_vote = @proposal.delegated_votes.find_by_user_id(current_user.id)
    end
    vote
  end

end
