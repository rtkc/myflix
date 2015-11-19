require 'spec_helper'

describe ReviewsController do
  describe "POST create" do

    context "valid input" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }
      let(:video) { Fabricate(:video) }
      
      it "sets @video" do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        expect(assigns(:video)).to eq(video)
      end
      it "sets @review" do  
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        expect(Review.count).to eq(1)
      end
      it "sets @current_user" do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        expect(Review.first.creator).to eq(current_user)
      end
      it "redirects to show video path of current video object" do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        response.should redirect_to(video_path(video))
      end
    end

    context "invalid input" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }
      let(:video) { Fabricate(:video) }

      it "does not create a review" do
        post :create, video_id: video.id, review: {rating: 4}
        expect(Review.count).to eq(0)
      end
      it "sets @video" do
        post :create, video_id: video.id, review: {rating: 4}
        expect(assigns(:video)).to eq(video)
      end
      it "renders video show page again" do
        post :create, video_id: video.id, review: {rating: 4}
        response.should render_template "videos/show"
      end
    end

    context "unauthenticated user" do
      let(:video) { Fabricate(:video) }

      it "redirects to sign in path" do
        post :create, video_id: video.id
        response.should redirect_to(sign_in_path)
      end
    end
  end
end