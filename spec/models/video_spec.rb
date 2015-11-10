require 'spec_helper'

describe Video do
  # no need to test video.save because video.save is implemented by rails automatically. We should only test code we write ourselves. 
  # we are testing that we have declared belongs_to and validates_presence_of relationships in Video Model (not its implementation)
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "search_by_title" do
    it "returns empty array if cannot find any videos" do
      monk = Video.create(title: "Monk", description: "Monk test video 1")
      expect(Video.search_by_title("James Bond")).to eq ([])
    end

    it "returns an array of one video for exact match" do
      monk = Video.create(title: "Monk", description: "Monk test video 1")
      expect(Video.search_by_title("Monk")).to eq([monk])
    end

    it "returns an array of all matches ordered by created_at" do
      monk = Video.create(title: "Monk", description: "Monk test video 1", created_at: 1.day.ago)
      monk2 = Video.create(title: "Monk 2", description: "Monk test video 2")
      expect(Video.search_by_title("Monk")).to eq([monk2, monk])
    end

    it "returns an array of one video if partial match" do
      monk = Video.create(title: "Monk", description: "Monk test video 1")
      expect(Video.search_by_title("onk")).to eq([monk])
    end

    it "returns an empty array for a search with an empty string" do
      monk = Video.create(title: "Monk", description: "Monk test video 1")
      expect(Video.search_by_title("")).to eq([])
    end
  end
end