require 'spec_helper'

describe Category do
  it { is_expected.to have_many(:videos) }

  describe "#recent_videos" do
    it "Returns only videos in specified category" do
      comedy = Category.create(name: "Comedy")
      3.times { Video.create(title: "Monk", description: "Monk test video 1", category: comedy, created_at: 7.day.ago) }
      drama = Category.create(name: "Drama")
      3.times { Video.create(title: "The Good Wife", description: "The Good Wife test video 1", category: drama, created_at: 7.day.ago) }
      expect(comedy.recent_videos.count).to eq(3)
    end

    it "Returns most recent videos in reverse chronological order" do
      comedy = Category.create(name: "Comedy")
      monk7 = Video.create(title: "Monk", description: "Monk test video 1", category: comedy, created_at: 7.day.ago)
      monk4 = Video.create(title: "Monk 4", description: "Monk test video 2", category: comedy, created_at: 4.day.ago)
      monk3 = Video.create(title: "Monk 5", description: "Monk test video 1", category: comedy, created_at: 3.day.ago)
      monk = Video.create(title: "Monk 7", description: "Monk test video 1", category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).to eq([monk, monk3, monk4, monk7])
    end

    it "Returns only 6 most recent videos" do
      comedy = Category.create(name: "Comedy")
      monk7 = Video.create(title: "Monk", description: "Monk test video 1", category: comedy, created_at: 7.day.ago)
      monk6 = Video.create(title: "Monk 4", description: "Monk test video 2", category: comedy, created_at: 6.day.ago)
      monk5 = Video.create(title: "Monk 4", description: "Monk test video 2", category: comedy, created_at: 5.day.ago)
      monk4 = Video.create(title: "Monk 4", description: "Monk test video 2", category: comedy, created_at: 4.day.ago)
      monk3 = Video.create(title: "Monk 5", description: "Monk test video 1", category: comedy, created_at: 3.day.ago)
      monk2 = Video.create(title: "Monk 7", description: "Monk test video 1", category: comedy, created_at: 2.day.ago)
      monk = Video.create(title: "Monk 7", description: "Monk test video 1", category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).to eq([monk, monk2, monk3, monk4, monk5, monk6])
    end

    it "Returns all videos if less than 6 videos in the category" do
      comedy = Category.create(name: "Comedy")
      monk = Video.create(title: "Monk", description: "Monk test video 1", category: comedy, created_at: 1.day.ago)
      monk2 = Video.create(title: "Monk 2", description: "Monk test video 2", category: comedy, created_at: 2.day.ago)
      monk3 = Video.create(title: "Monk 3", description: "Monk test video 1", category: comedy, created_at: 3.day.ago)
      expect(comedy.recent_videos.count).to eq(3)
    end

    it "Returns empty array if no videos in category" do
      comedy = Category.create(name: "Comedy")
      expect(comedy.recent_videos).to eq([])
    end
  end
end