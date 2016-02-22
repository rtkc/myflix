require 'spec_helper' 

describe RelationshipsController do 
  describe "GET index" do
    it "gets current user's @following_relationships" do 
      alice = Fabricate(:user)
      jim = Fabricate(:user)
      set_current_user(jim)
      following_relationship1 = Fabricate(:relationship, follower: jim, leader: alice)
      following_relationship2 = Fabricate(:relationship, follower: jim, leader: alice)
      get :index
      expect(assigns(:following_relationships)).to eq([following_relationship1, following_relationship2])
    end

    it_behaves_like "require_sign_in" do 
      let(:action) { get :index}
    end
  end

  describe "POST create" do 
    it "creates @following_relationship" do 
      alice = Fabricate(:user)
      jim = Fabricate(:user)
      set_current_user(jim)
      post :create, user_id: alice.id
      expect(jim.following_relationships.count).to eq(1)
    end

    it "user cannot follow himself" do
      jim = Fabricate(:user)
      set_current_user(jim)
      post :create, user_id: jim.id
      expect(jim.following_relationships.count).to eq(0)
    end

    it "user cannot follow same user twice" do 
      alice = Fabricate(:user)
      jim = Fabricate(:user)
      set_current_user(jim)
      Fabricate(:relationship, follower: jim, leader: alice)
      post :create, user_id: alice.id
      expect(jim.following_relationships.count).to eq(1)
    end

    it "redirects to people page" do 
      jim = Fabricate(:user)
      set_current_user(jim)
      post :create, user_id: jim.id
      expect(response).to redirect_to people_path
    end

    it_behaves_like "require_sign_in" do 
      let(:action) { post :create, user_id: 1 }
    end
  end

  describe "DELETE destroy" do
    it "destroys @following_relationship" do 
      jim = Fabricate(:user)
      set_current_user(jim)
      alice = Fabricate(:user)
      following_relationship = Fabricate(:relationship, follower: jim, leader: alice)
      delete :destroy, id: following_relationship.id
      expect(jim.following_relationships.count).to eq(0)
    end

    it "does not delete following_relationship if current user is not the follower" do 
      jim = Fabricate(:user)
      set_current_user(jim)
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      following_relationship = Fabricate(:relationship, follower: bob, leader: alice)
      delete :destroy, id: following_relationship.id
      expect(bob.following_relationships.count).to eq(1)
    end

    it "redirects to people page whether unfollowing action was successful or unsuccessful" do 
      jim = Fabricate(:user)
      set_current_user(jim)
      alice = Fabricate(:user)
      following_relationship = Fabricate(:relationship, follower: jim, leader: alice)
      delete :destroy, id: following_relationship.id
      expect(response).to redirect_to people_path
    end

    it_behaves_like "require_sign_in" do 
      let(:action) { delete :destroy, id: 1}
    end
  end
end 