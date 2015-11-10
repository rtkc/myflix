require 'spec_helper'

describe Category do
  it { should have_many(:videos) }

  describe "#recent_videos" do
    it "Shows most recent videos in reverse chronological order" do
      comedy = Category.create(name: "Comedy")
      monk7 = Video.create(title: "Monk", description: "Monk test video 1", category: comedy, created_at: 7.day.ago)
      monk6 = Video.create(title: "Monk 2", description: "Monk test video 2", category: comedy, created_at: 6.day.ago)
      monk5 = Video.create(title: "Monk 3", description: "Monk test video 1", category: comedy, created_at: 5.day.ago)
      monk4 = Video.create(title: "Monk 4", description: "Monk test video 2", category: comedy, created_at: 4.day.ago)
      monk3 = Video.create(title: "Monk 5", description: "Monk test video 1", category: comedy, created_at: 3.day.ago)
      monk2 = Video.create(title: "Monk 6", description: "Monk test video 2", category: comedy, created_at: 2.day.ago)
      monk = Video.create(title: "Monk 7", description: "Monk test video 1", category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).to eq([monk, monk2, monk3, monk4, monk5, monk6])
    end

    it "Shows 6 most recent videos in reverse chronological order" do
      comedy = Category.create(name: "Comedy")
      monk7 = Video.create(title: "Monk", description: "Monk test video 1", category: comedy, created_at: 7.day.ago)
      monk6 = Video.create(title: "Monk 2", description: "Monk test video 2", category: comedy, created_at: 6.day.ago)
      monk5 = Video.create(title: "Monk 3", description: "Monk test video 1", category: comedy, created_at: 5.day.ago)
      monk4 = Video.create(title: "Monk 4", description: "Monk test video 2", category: comedy, created_at: 4.day.ago)
      monk3 = Video.create(title: "Monk 5", description: "Monk test video 1", category: comedy, created_at: 3.day.ago)
      monk2 = Video.create(title: "Monk 6", description: "Monk test video 2", category: comedy, created_at: 2.day.ago)
      monk = Video.create(title: "Monk 7", description: "Monk test video 1", category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).to eq([monk, monk2, monk3, monk4, monk5, monk6])
    end

    it "Shows all videos if less than 6 videos in the category" do
      comedy = Category.create(name: "Comedy")
      monk = Video.create(title: "Monk", description: "Monk test video 1", category: comedy, created_at: 1.day.ago)
      monk2 = Video.create(title: "Monk 2", description: "Monk test video 2", category: comedy, created_at: 2.day.ago)
      monk3 = Video.create(title: "Monk 3", description: "Monk test video 1", category: comedy, created_at: 3.day.ago)
      expect(comedy.recent_videos).to eq([monk, monk2, monk3])
    end

    it "Returns empty array if no videos in category" do
      comedy = Category.create(name: "Comedy")
      horror = Category.create(name: "Horror")
      expect(comedy.recent_videos).to eq([])
    end
  end
end