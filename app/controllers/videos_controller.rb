class VideosController < AuthenticatedController
  
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
    @review = Review.new
  end

  def search
    @videos = Video.search_by_title(params[:search_term])
  end
end