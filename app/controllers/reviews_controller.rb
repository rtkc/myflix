class ReviewsController < AuthenticatedController

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(review_params)
    @review.creator = current_user

    if @review.save
      flash[:success] = "Your review was successfully submitted. Thanks for your review!"
      redirect_to video_path(@video)
    else
      render 'videos/show'
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :review)
  end
end