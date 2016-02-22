class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @following_relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:user_id])
    follow(leader) if current_user.can_follow?(leader)
    redirect_to people_path
  end

  def destroy
    following_relationship = Relationship.find(params[:id])
    if following_relationship.follower == current_user
      following_relationship.destroy
      flash[:success] = "You have successfully unfollowed this person."
      redirect_to people_path
    else
      flash[:error] = "Sorry, something went wrong. You are still following this person."
      redirect_to people_path
    end
  end

  private 
  def follow(leader)
    Relationship.create(follower: current_user, leader: leader)
  end
end