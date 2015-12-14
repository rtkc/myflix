require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      set_current_user
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets @review for authenticated users" do
      set_current_user
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:review)).to be_a_new(Review)
    end

    it_behaves_like "require_sign_in" do
      let!(:action) { get :show, id: Fabricate(:video).id }
    end
  end

  describe "GET search" do
    it "sets the @videos variable based on search term" do
      set_current_user
      monk = Fabricate(:video, title: "monk")
      get :search, search_term: "monk"
      expect(assigns(:videos)).to include(monk)
    end

    it_behaves_like "require_sign_in" do
      let!(:action) { get :search, search_term: "monk" }
    end
  end
end 