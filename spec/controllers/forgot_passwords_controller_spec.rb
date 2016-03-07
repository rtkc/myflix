require 'spec_helper'

describe ForgotPasswordsController do 

  describe "POST create" do 

    let(:alice) { Fabricate(:user) }

    context "with blank input" do 
      it "renders new template" do 
        post :create, email: ""
        expect(response).to render_template :new
      end

      it "prompts user to input a correct email" do 
        post :create, email: ""
        expect(flash[:error]).to eq("Please enter a valid email.")
      end
    end

    context "with existing email" do 
      it "sets reset password token for user" do 
        post :create, email: alice.email 
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sets a token for the user with this email" do
        expect(alice.token).to be_nil
        post :create, email: alice.email 
        expect(alice.reload.token).not_to be_nil
      end

      it "sends email" do 
        post :create, email: alice.email 
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends email to correct user" do 
        post :create, email: alice.email 
        expect(ActionMailer::Base.deliveries.last.to).to eq([alice.email])
      end
    end

    context "with non-existing email" do 
      it "renders new template" do 
        post :create, email: ""
        expect(response).to render_template :new
      end

      it "prompts user to input a correct email" do 
        post :create, email: ""
        expect(flash[:error]).to eq("Please enter a valid email.")
      end
    end
  end
end