require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items" do
      current_user = Fabricate(:user)
      session[:user_id] = current_user.id
      queue_item1 = QueueItem.create(user_id: current_user.id, video_id: 1, order: 1 )
      queue_item2 = QueueItem.create(user_id: current_user.id, video_id: 2, order: 2)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirects to sign_in page for unauthenticted users" do
      get :index
      response.should redirect_to(sign_in_path)
    end
  end

  describe "POST create" do
    context "authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user }
      let(:video) { Fabricate(:video) }

      it "sets @queue_item" do
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end
      it "sets @user" do
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end
      it "sets @video" do
        post :create, video_id: video.id
        expect(assigns(:video)).to eq(video)
      end
      it "creates queue_item record" do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it "renders to video show template after saving queue_item record" do
        post :create, video_id: video.id
        response.should redirect_to(video_path(video))
      end
    end

    it "redirects to sign in path for unauthenticted users" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        response.should redirect_to(sign_in_path)
      end
  end

  describe "POST destroy" do
    context "authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user }
      let(:video) { Fabricate(:video) }
    end
    it "destroys queue_item record" do
      post :create, video_id: video.id
      
    end
    it "renders new my queue template" do
    end
  end
end