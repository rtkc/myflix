require 'spec_helper'

describe InvitationsController do 

  describe "GET new" do 

    it "sets @invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end

    it "redirects to sign in page if not signed in" do 
      get :new
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST create" do 
    context "signed in" do 
      before do 
        set_current_user
      end

      context "valid input" do 
        before do 
          post :create, invitation: { recipient_name: 'Jim', recipient_email: 'Jim@email.com', message: 'MyFlix is the best.' }
        end

        it "saves new invitation" do
          expect(Invitation.count).to eq(1)
        end

        it "sends invitation mail" do 
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it "sends invitation to correct recipient" do 
          expect(ActionMailer::Base.deliveries.last.to).to eq(["Jim@email.com"])
        end

        it "redirects to home page" do 
          expect(response).to redirect_to home_path
        end

        it "flashes success message" do 
          expect(flash.now[:success]).to eq("Your inviitation was successfully sent.")
        end
      end

      context "invalid input" do 
        before do 
          post :create, invitation: { recipient_email: 'Jim@email.com', message: 'MyFlix is the best.' }
        end
        it "renders new template" do
          expect(response).to render_template :new
        end

        it "flashes unsuccessful message" do 
          expect(flash.now[:error]).to eq("Your invitation could not be sent. Please try again.")
        end
      end
    end

    context "not signed in" do 
      it "redirects to signed in page" do 
        post :create
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end