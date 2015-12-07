require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items" do
      current_user = Fabricate(:user)
      session[:user_id] = current_user.id
      queue_item1 = QueueItem.create(user_id: current_user.id, video_id: 1, position: 1 )
      queue_item2 = QueueItem.create(user_id: current_user.id, video_id: 2, position: 2)
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

      it "creates queue_item record" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it "renders to video show template after saving queue_item record" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        response.should redirect_to(video_path(video))
      end
      it "creates queue item associated with video" do
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end
      it "creates queue item associated with signed in user" do
        video = Fabricate(:video)
        post :create,  video_id: video.id
        expect(QueueItem.first.user).to eq(current_user)
      end
      it "puts video as last one in queue" do
        monk = Fabricate(:video)
        post :create, video_id: monk.id
        south_park = Fabricate(:video)
        post :create, video_id: south_park.id
        find_south_park_queue_item = QueueItem.where(video_id: south_park.id, user_id: current_user.id).first
        expect(find_south_park_queue_item.position).to eq(2)
      end
      it "does not add video to queue if video already exists in queue" do
        monk = Fabricate(:video)
        post :create, video_id: monk.id
        post :create, video_id: monk.id
        count_monk_queue_item = QueueItem.where(video_id: monk.id, user_id: current_user.id).count
        expect(count_monk_queue_item).to eq(1)
      end
    end
    
    it "redirects to sign in path for unauthenticted users" do
      video = Fabricate(:video)
      post :create, video_id: video.id
      response.should redirect_to(sign_in_path)
    end
  end

  describe "POST update" do 
    context "with authenticated user" do 
      let(:alice) { Fabricate(:user) }
      before { session[:user_id] = alice }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2) }
    
      context "with valid input" do 
        it "redirect to my queue page" do 
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          response.should redirect_to(queue_items_path)
        end

        it "reorder queue items" do 
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(alice.queue_items).to eq([queue_item2, queue_item1])
        end

        it "normalizes queue items" do 
          post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1}]
          expect(alice.queue_items.map(&:position)).to eq([1, 2])
        end
      end

      context "with invalid input" do 
        it "redirects to queue page" do 
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2.1}, {id: queue_item2.id, position: 1}]
          response.should redirect_to(queue_items_path)
        end
        it "flashes error message" do 
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2.1}, {id: queue_item2.id, position: 1}]
          expect(flash[:danger]).to be_present
        end
        it "does not redorder queue items" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2.1}, {id: queue_item2.id, position: 1}]
        expect(alice.queue_items).to eq([queue_item1, queue_item2])
      end
      end
    end

    context "with unauthenticted users" do 
      it "redirects to sign in path" do 
        post :update_queue, queue_items: [{id: 2, position: 3}, {id: 5, position: 2}]
        expect(response).to redirect_to sign_in_path
      end
    end 

    context "with queue items that do not belong to the current user" do 
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }
      before { session[:user_id] = alice }

      it "does not redorder queue items" do 
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1)
        queue_item2 = Fabricate(:queue_item, user: bob, position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(bob.queue_items).to eq([queue_item1, queue_item2])
      end
    end
  end

  describe "DELETE destroy" do
    context "authenticated users" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user }

      it "destroys queue_item record" do
        monk = Fabricate(:video)
        monk_queue_item = Fabricate(:queue_item, video_id: monk.id, user: current_user)
        delete :destroy, id: monk_queue_item.id
        count_monk_queue_item = QueueItem.where(video_id: monk.id, user_id: current_user.id).count
        expect(count_monk_queue_item).to eq(0)
      end
      it "redirects to new my queue page" do
        monk = Fabricate(:video)
        monk_queue_item = Fabricate(:queue_item, video_id: monk.id, user: current_user)
        delete :destroy, id: monk_queue_item.id
        count_monk_queue_item = QueueItem.where(video_id: monk.id, user_id: current_user.id).count
        response.should redirect_to(queue_items_path) 
      end
      it "normalizes queue items" do 
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        delete :destroy, id: queue_item1.id
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context "unauthenticted users" do 
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }
      before { session[:user_id] = bob }

      it "does not destroy queue_item record" do 
        monk = Fabricate(:video)
        monk_queue_item = Fabricate(:queue_item, video_id: monk.id, user: alice)
        delete :destroy, id: monk_queue_item.id
        expect(alice.queue_items.count).to eq(1)
      end
      it "redirects to sign in page" do 
        monk = Fabricate(:video)
        monk_queue_item = Fabricate(:queue_item, video_id: monk.id, user: alice)
        delete :destroy, id: monk_queue_item.id
        count_monk_queue_item = QueueItem.where(video_id: monk.id, user_id: alice.id).count
        delete :destroy, id: monk_queue_item.id
        response.should redirect_to(sign_in_path) 
      end
    end
  end
end