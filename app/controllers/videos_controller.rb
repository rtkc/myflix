class VideosController < ApplicationController
  before_action :require_user
  
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @review = Review.new
    @reviews = @video.reviews.reload
  end

  def search
    @videos = Video.search_by_title(params[:search_term])
  end
end