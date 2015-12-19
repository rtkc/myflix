require 'spec_helper'

describe User do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:full_name) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to have_many(:queue_items).order(:position) }

  describe "#queued_video?" do
    it "returns true when the user queue has video" do 
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, video: video, user: user) 
      expect(user.queued_video?(video)).to be(true)
    end
    it "returns true when the user queue has video" do 
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be(false)
    end
  end
end