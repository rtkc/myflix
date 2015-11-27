require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      monk = Fabricate(:video, title: 'Monk')
      queue_item = QueueItem.create(video: monk)
      expect(queue_item.video_title).to eq('Monk')
    end
  end

  describe "#category" do
    it "returns category name of associated video" do 
      comedy = Category.create(name: 'Comedy')
      monk = Fabricate(:video, title: 'Monk', category: comedy)
      queue_item = QueueItem.create(video: monk)
      expect(queue_item.category).to eq(comedy)
    end
  end

  describe "#category_name" do
    it "returns category name of associated video" do 
      comedy = Category.create(name: 'Comedy')
      monk = Fabricate(:video, title: 'Monk', category: comedy)
      queue_item = QueueItem.create(video: monk)
      expect(queue_item.category_name).to eq('Comedy')
    end
  end

  describe "#rating" do
    it "returns the rating from the review when the review is present" do 
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, creator: user, video: video, rating: 4)
      queue_item = QueueItem.create(user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end

    it "returns nil if no review" do 
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = QueueItem.create(user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end
end