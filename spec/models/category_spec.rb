require 'spec_helper'

describe Category do
  it { is_expected.to have_many(:videos) }

  describe "#recent_videos" do
    it "Returns only videos in specified category" do
      comedy = Fabricate(:category)
      Fabricate.times(3, :video, category: comedy, created_at: 7.day.ago)
      drama = Fabricate(:category)
      Fabricate.times(3, :video, category: drama, created_at: 7.day.ago)
      expect(comedy.recent_videos.count).to eq(3)
    end

    it "Returns most recent videos in reverse chronological order" do
      comedy = Fabricate(:category)
      monk7 = Fabricate(:video, category: comedy, created_at: 7.day.ago)
      monk4 = Fabricate(:video, category: comedy, created_at: 4.day.ago)
      monk3 = Fabricate(:video, category: comedy, created_at: 3.day.ago)
      monk = Fabricate(:video, category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).to eq([monk, monk3, monk4, monk7])
    end

    it "Returns only 6 most recent videos" do
      comedy = Fabricate(:category)
      monk7 = Fabricate(:video, category: comedy, created_at: 7.day.ago)
      monk6 = Fabricate(:video, category: comedy, created_at: 6.day.ago)
      monk5 = Fabricate(:video, category: comedy, created_at: 5.day.ago)
      monk4 = Fabricate(:video, category: comedy, created_at: 4.day.ago)
      monk3 = Fabricate(:video, category: comedy, created_at: 3.day.ago)
      monk2 = Fabricate(:video, category: comedy, created_at: 2.day.ago)
      monk = Fabricate(:video, category: comedy, created_at: 1.day.ago)
      expect(comedy.recent_videos).to eq([monk, monk2, monk3, monk4, monk5, monk6])
    end

    it "Returns all videos if less than 6 videos in the category" do
      comedy = Fabricate(:category)
      monk = Fabricate(:video, category: comedy, created_at: 1.day.ago)
      monk2 = Fabricate(:video, category: comedy, created_at: 2.day.ago)
      monk3 = Fabricate(:video, category: comedy, created_at: 3.day.ago)
      expect(comedy.recent_videos.count).to eq(3)
    end

    it "Returns empty array if no videos in category" do
      comedy = Fabricate(:category)
      expect(comedy.recent_videos).to eq([])
    end
  end
end