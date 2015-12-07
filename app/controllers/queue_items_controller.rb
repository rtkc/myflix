require 'pry'
class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items.all
    @review = Review.new
  end

  def create
    @video = Video.find(params[:video_id])
    @queue_item = @video.queue_items.build(video_id: params[:video_id], position: assign_new_order_position, user: current_user)

    if no_duplicates?(@video) && @queue_item.save 
      flash[:success] = "Video was added to your queue successfully"
      redirect_to video_path(@video)
    else
      flash[:danger] = "This video could not be added to your queue. This video may already exist in your queue."
      redirect_to video_path(@video)
    end
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_positions  
    rescue ActiveRecord::RecordInvalid 
      flash[:danger] = "Invalid position numbers."
    end
    redirect_to queue_items_path
  end

  def destroy
    @queue_item = QueueItem.find(params[:id])

    if current_user.queue_items.include?(@queue_item) && @queue_item.destroy
      current_user.normalize_queue_item_positions
      flash[:success] = "Queued item has been removed from your queue."
      redirect_to queue_items_path
    else
      flash[:danger] = "You need to be the owner of this queue to remove an item."
      redirect_to sign_in_path
    end
  end

  private 
  def assign_new_order_position
    current_user.queue_items.count + 1
  end

  def no_duplicates?(video)
    if QueueItem.where(video_id: video.id, user_id: current_user.id).count == 0
      return true
    else
      false
    end
  end

  def update_queue_items
    ActiveRecord::Base.transaction do 
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data["id"])
        if queue_item.user == current_user
          queue_item.update_attributes!(position: queue_item_data["position"]) 
        end
      end
    end
  end
end