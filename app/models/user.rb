class User < ActiveRecord::Base
  has_secure_password validations: false
  
  has_many :reviews
  has_many :queue_items, -> {order(:position)}

  has_many :followers, :through => :leading_relationships
  has_many :leading_relationships, :class_name => "Relationship", :foreign_key => "leader_user_id"

  has_many :leaders, :through => :following_relationships
  has_many :following_relationships, :class_name => "Relationship", :foreign_key => "follower_user_id"
  
  validates :full_name, presence: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates :email, presence: true, uniqueness: true

  def normalize_queue_item_positions 
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def following?(leader)
    following_relationships.map(&:leader).include?(leader) 
  end

  def can_follow?(leader)
    !(self == leader || self.following?(leader))
  end
end