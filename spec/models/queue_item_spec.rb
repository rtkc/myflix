require 'spec_helper'

describe QueueItem do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:video) }
  it { is_expected.to validate_numericality_of(:position).only_integer }

  describe "#video_title" do
    it "returns the title of the associated video" do
      monk = Fabricate(:video, title: 'Monk')
      queue_item = Fabricate(:queue_item, video: monk)
      expect(queue_item.video_title).to eq('Monk')
    end
  end

  describe "#category" do
    it "returns category name of associated video" do 
      comedy = Fabricate(:category)
      monk = Fabricate(:video, title: 'Monk', category: comedy)
      queue_item = Fabricate(:queue_item, video: monk)
      expect(queue_item.category).to eq(comedy)
    end
  end

  describe "#category_name" do
    it "returns category name of associated video" do 
      comedy = Fabricate(:category, name: 'Comedy')
      monk = Fabricate(:video, title: 'Monk', category: comedy)
      queue_item = Fabricate(:queue_item, video: monk)
      expect(queue_item.category_name).to eq('Comedy')
    end
  end

  describe "#rating" do
    it "returns the rating from the review when the review is present" do 
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, creator: user, video: video, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end

    it "returns nil if no review" do 
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

  
  describe "#rating=" do 
    it "changes rating if review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, creator: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it "creates rating if review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it "clears rating if review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, creator: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil
      expect(Review.first.rating).to be_nil
    end
  end
end