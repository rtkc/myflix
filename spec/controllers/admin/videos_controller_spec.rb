require 'spec_helper' 

describe Admin::VideosController do 
  describe "GET new" do 
    it "sets @video to new video" do
      set_admin
      get :new
      expect(assigns(:video)).to be_a_new Video
    end
    it_behaves_like "require_admin" do 
      let(:action) { get :new }
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do 
    context "validated admin" do
      before { set_admin }

      context "valid input" do   
        it "creates new video" do 
          post :create, video: Fabricate.attributes_for(:video)
          expect(Video.count).to eq(1)
        end

        it "flashes success message" do 
          post :create, video: Fabricate.attributes_for(:video)
          expect(flash[:success]).to be_present
        end

        it "redirects to add new video page" do 
          post :create, video: Fabricate.attributes_for(:video)
          expect(response).to redirect_to new_admin_video_path
        end
      end

      context "invalid input" do 
        it "sets @video variable" do 
          post :create, video: Fabricate.attributes_for(:video, title: '')
          expect(assigns(:video)).to be_present
        end

        it "does not create a new video" do 
          post :create, video: Fabricate.attributes_for(:video, title: '')
          expect(Video.count).to eq(0)
        end

        it "renders new add video template" do 
          post :create, video: Fabricate.attributes_for(:video, title: '')
          expect(response).to render_template :new
        end

        it "flashes error message" do 
          post :create, video: Fabricate.attributes_for(:video, title: '')
          expect(flash[:error]).to be_present
        end
      end
    end

    context "not admin" do 
      it_behaves_like "require_admin" do 
        let(:action) { post :create }
      end

      it_behaves_like "require_sign_in" do
        let(:action) { post :create }
      end
    end
  end
end