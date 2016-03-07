require_relative '../../lib/tokenable'

class Invitation < ActiveRecord::Base
  include Tokenable

  before_save :generate_token

  belongs_to :inviter, foreign_key: 'inviter_id', class_name: 'User'

  validates_presence_of :inviter, :recipient_email, :recipient_name
end