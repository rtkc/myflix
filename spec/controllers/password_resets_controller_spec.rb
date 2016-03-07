require 'spec_helper' 

describe PasswordResetsController do 

  describe "GET show" do 

    let(:alice) { Fabricate(:user, token: '12345') }

    context "valid token" do 
      it "renders the show template" do
        alice.update_column(:token, '12345') 
        get :show, id: '12345'
        expect(response).to render_template :show
      end
    end

    context "invalid token" do 
      it "redirects to expired token page" do 
        get :show, id: ''
        expect(response).to redirect_to expired_token_path
      end
    end
  end

  describe "POST create" do 

    let(:alice) { Fabricate(:user, token: '12345') }

    context "with valid token and valid password" do 
      it "redirects to sign in page" do 
        alice.update_column(:token, '12345') 
        post :create, token: '12345', password: 'password'
        expect(response).to redirect_to sign_in_path
      end

      it "updates user's password" do 
        alice.update_column(:token, '12345') 
        post :create, token: '12345', password: 'password'
        expect(alice.reload.authenticate('password')).to be_truthy
      end
      
      it "destroys user's token after password has been updated" do 
        alice.update_column(:token, '12345') 
        post :create, token: '12345', password: 'password'
        expect(alice.reload.token).to be_nil
      end
    end

    context "with empty password" do 
      it "flashes error message" do 
        alice.update_column(:token, '12345') 
        post :create, token: '12345', password: ''
        expect(flash.now[:error]).to eq("Please enter a password.")
      end

      it "renders new template" do 
        alice.update_column(:token, '12345') 
        post :create, token: '12345', password: ''
        expect(response).to render_template :show
      end
    end
  end
end