require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
      let(:video) { Fabricate(:video) }
    
    context "with authenticated users" do
      before { set_current_user }
    
      context "valid input" do
        it "sets @video" do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(assigns(:video)).to eq(video)
        end
        it "creates a review" do  
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(Review.count).to eq(1)
        end
        it "creates a review associated with the video" do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(Review.first.video).to eq(video)
        end
        it "redirects to show video path of current video object" do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(response).to redirect_to(video_path(video))
        end
        it "creates a review associated with the signed in user" do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
          expect(Review.first.creator).to eq(current_user)
        end
      end

      context "invalid input" do
        before { set_current_user }
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
          expect(response).to render_template "videos/show"
        end
        it "does not save review to database" do
          post :create, video_id: video.id, review: {rating: 4}
          expect(Video.first.reviews.empty?).to be true
        end
      end
    end

    context "unauthenticated user" do
      it_behaves_like "require_sign_in" do
        let!(:action) { post :create, video_id: Fabricate(:video).id }
      end
    end
  end
end