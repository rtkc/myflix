class Video < ActiveRecord::Base 
  attr_reader :search_term

  belongs_to :category
  has_many :reviews, -> { order('created_at DESC') }
  has_many :queue_items, -> {order(:position)}

  validates_presence_of :title, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title ILIKE ?", "%#{search_term}%").order("created_at DESC")
  end
end