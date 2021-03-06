require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice, video_id: 1, position: 1 )
      queue_item2 = Fabricate(:queue_item, user: alice, video_id: 2, position: 2)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it_behaves_like "require_sign_in" do 
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    context "authenticated users" do
      it "creates queue_item record" do
        set_current_user
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
      it "renders to video show template after saving queue_item record" do
        set_current_user
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to(video_path(video))
      end
      it "creates queue item associated with video" do  
        set_current_user
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end
      it "creates queue item associated with signed in user" do
        alice = Fabricate(:user)
        set_current_user(alice)
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(alice)
      end
      it "puts video as last one in queue" do
        alice = Fabricate(:user)
        set_current_user(alice)
        monk = Fabricate(:video)
        post :create, video_id: monk.id
        south_park = Fabricate(:video)
        post :create, video_id: south_park.id
        find_south_park_queue_item = QueueItem.find_by(video_id: south_park.id, user_id: alice.id)
        expect(find_south_park_queue_item.position).to eq(2)
      end
      it "does not add video to queue if video already exists in queue" do
        alice = Fabricate(:user)
        set_current_user(alice)
        monk = Fabricate(:video)
        post :create, video_id: monk.id
        post :create, video_id: monk.id
        count_monk_queue_item = QueueItem.where(video_id: monk.id, user_id: alice.id).count
        expect(count_monk_queue_item).to eq(1)
      end
    end
    
    context "for unauthenticted users" do
      it_behaves_like "require_sign_in" do 
        let!(:action) { post :create, video_id: Fabricate(:video).id }
      end
    end
  end

  describe "POST update_queue" do 
    context "with authenticated user" do 
      let(:alice) { Fabricate(:user) }
      before { set_current_user(alice) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2) }
    
      context "with valid input" do 
        it "redirect to my queue page" do 
          post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
          expect(response).to redirect_to(queue_items_path)
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
          expect(response).to redirect_to(queue_items_path)
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
      it_behaves_like "require_sign_in" do 
        let!(:action) { post :update_queue, queue_items: [{id: 2, position: 3}, {id: 5, position: 2}] }
      end
    end 

    context "with queue items that do not belong to the current user" do 
      let(:alice) { Fabricate(:user) }
      let(:bob) { Fabricate(:user) }
      before { set_current_user(alice) }

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
      before { set_current_user }

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
        expect(response).to redirect_to(queue_items_path) 
      end
      it "normalizes queue items" do 
        queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
        delete :destroy, id: queue_item1.id
        expect(queue_item2.reload.position).to eq(1)
      end
    end

    context "unauthenticted users" do 
      it "does not destroy queue_item record" do 
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        set_current_user(bob)
        monk = Fabricate(:video)
        monk_queue_item = Fabricate(:queue_item, video_id: monk.id, user: alice)
        delete :destroy, id: monk_queue_item.id
        expect(alice.queue_items.count).to eq(1)
      end
      it_behaves_like "require_sign_in" do 
        let!(:action) { delete :destroy, id: Fabricate(:queue_item).id }
      end
    end
  end
end