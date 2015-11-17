require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redrects to home_path if logged in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      response.should redirect_to(home_path)
    end

    it "renders new template if not logged in" do
      get :new
      response.should render_template(:new)
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
        response.should redirect_to(home_path)
      end
    end

    context "invalid user input" do
      it "redirects to sign in path" do
        post :create
        response.should redirect_to(sign_in_path)
      end
    end
  end
end