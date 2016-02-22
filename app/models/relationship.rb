class Relationship < ActiveRecord::Base
  belongs_to :leader, :class_name => "User", :foreign_key => "leader_user_id"
  belongs_to :follower, :class_name => "User", :foreign_key => "follower_user_id"
end