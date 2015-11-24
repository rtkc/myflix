class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items.all
  end

  def create
    @video = Video.find(params[:video_id])
    @queue_item = @video.queue_items.build(video_id: params[:video_id])
    @queue_item.user = current_user

    if @queue_item.save 
      flash[:success] = "Video was added to your queue successfully"
      redirect_to video_path(@video)
    else
      flash[:error] = "Video was not successfully added to your queue. Please try again."
      redirect_to video_path(@video)
    end
  end

  def destroy
  end
end