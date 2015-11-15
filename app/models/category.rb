class Category < ActiveRecord::Base
  has_many :videos

  def recent_videos
    return [] if self.id.blank?
    Video.where("category_id = ?", "#{self.id}").order("created_at DESC").first(6)
  end
end