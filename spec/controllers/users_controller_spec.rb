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
        post :create, user: Fabricate.attributes_for(:user, full_name: " ", password: " ")
        expect(response).to render_template :new
      end

      it "sets @user" do
        post :create, user: Fabricate.attributes_for(:user, full_name: " ", password: " ")
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    context "email sending" do 

      after { ActionMailer::Base.deliveries.clear }

      context "valid input" do 
        it "sends out the email" do 
          post :create,  user: Fabricate.attributes_for(:user) 
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it "sends to the right recipient" do 
          post :create,  user: Fabricate.attributes_for(:user, email: "jim@email.com") 
          expect(ActionMailer::Base.deliveries.last.to).to eq(['jim@email.com'])
        end

        it "contains user's name in email body" do
          post :create,  user: Fabricate.attributes_for(:user, full_name: "Jim Tealeaf") 
          expect(ActionMailer::Base.deliveries.last.body).to include('Jim Tealeaf')
        end
      end

      context "invalid input" do 
        it "does not send out the email" do 
          post :create,  user: Fabricate.attributes_for(:user, full_name: "") 
          expect(ActionMailer::Base.deliveries).to be_empty
        end
      end
    end
  end

  describe "GET show" do
    context "for authenticated users" do
      before do 
        @alice = Fabricate(:user)
        set_current_user(@alice)
        @jim = Fabricate(:user)
      end

      it "sets @user" do 
        get :show, id: @jim.id
        expect(assigns(:user)).to eq(@jim)
      end
    end

    context "for unauthenticted users" do
      before { @jim = Fabricate(:user) }

      it_behaves_like "require_sign_in" do 
        let!(:action) { get :show, id: @jim.id }
      end
    end
  end
end