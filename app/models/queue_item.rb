class QueueItem < ActiveRecord::Base
  belongs_to :user, foreign_key: 'user_id', class_name: 'User'
  belongs_to :video, foreign_key: 'video_id', class_name: 'Video'

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.name
  end

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end
end