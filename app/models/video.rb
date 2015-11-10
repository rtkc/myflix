class Video < ActiveRecord::Base 
  attr_reader :search_term

  belongs_to :category

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title ILIKE ?", "%#{search_term}%").order("created_at DESC")
  end
end