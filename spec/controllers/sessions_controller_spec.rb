require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redrects to home_path if logged in" do
      set_current_user
      get :new
      expect(response).to redirect_to(home_path)
    end

    it "renders new template if not logged in" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    context "valid user input" do
      let(:user) { Fabricate(:user) }
      it "creates new session" do
        post :create, email: user.email, password: user.password
        expect(session[:user_id]).to eq(user.id)
      end
      it "redirects to home path" do
        post :create, email: user.email, password: user.password
        expect(response).to redirect_to(home_path)
      end
    end

    context "invalid user input" do
      it_behaves_like "require_sign_in" do
        let(:action) { post :create }
      end
    end
  end
end