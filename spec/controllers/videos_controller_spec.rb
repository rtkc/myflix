require 'spec_helper'

describe VideosController do
  describe "GET index" do
    it "sets the @categories variable" do
      comedy = Category.create(name: "Comedy")
      drama = Category.create(name: "Drama")

      get :index
      assigns(:categories).should == [comedy, drama]
    end
    it "renders the index template" do
      get :index
      response.should render_template :index
    end
  end
end