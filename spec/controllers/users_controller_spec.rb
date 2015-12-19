require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    it "renders new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context "valid user input" do 
      before do 
        post :create, user: Fabricate.attributes_for(:user)
      end
      
      it "creates user record" do       
        expect(User.count).to eq(1)
      end

      it "redirects to root path" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "invalid user input" do

      it "renders new template" do
        post :create, user: { full_name: "Jim Bob", password: "password" }
        expect(response).to render_template :new
      end

      it "sets @user" do
        post :create, user: { full_name: "Jim Bob", password: "password" }
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
end