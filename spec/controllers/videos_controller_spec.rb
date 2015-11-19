require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "redirects to sign_in path if user not signed in" do
      video = Fabricate(:video)
      get :show, id: video.id
      response.should redirect_to(sign_in_path)
    end
  end

  describe "GET search" do
    it "sets the @videos variable based on search term" do
      session[:user_id] = Fabricate(:user).id
      monk = Fabricate(:video, title: "monk")
      get :search, search_term: "monk"
      expect(assigns(:videos)).to include(monk)
    end

    it "redirects to sign_in path if user not signed in" do
      get :search, search_term: "monk"
      response.should redirect_to(sign_in_path)
    end
  end
end 