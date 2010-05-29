require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GenresController do
  before(:each) do
    Authorization.ignore_access_control(true) 
  end

  describe "GET index" do
    it "should respond" do
      get :index
    end
  end
  
  describe "POST create" do
    before(:each) do
      @genre = mock_model(Genre, :save => nil)
      Genre.stub(:new).and_return(@genre)
    end

    it "creates a new genre" do
      Genre.should_receive(:new).with("name" => "salme")
      post :create, :genre => { "name" => "salme" }
    end
  
    it "saves the genre" do
      @genre.should_receive(:save)
      post :create
    end

    context "when the genre saves successfully" do
      before(:each) do
        @genre.stub(:save).and_return(true)
      end
    
      it "sets a flash[:notice] message" do
        post :create
        flash[:notice].should == "Genre opprettet."
      end
    
      it "redirects to the genres index" do
        post :create
        response.should redirect_to(genres_path)
      end
    end

    context "when the genre fails to save" do
      before(:each) do
        @genre.stub(:save).and_return(false)
      end
    
      it "assigns @genre" do
        post :create
        assigns[:genre].should == @genre
      end

      it "renders the new template" do
        post :create
        response.should render_template("new")
      end
    end
  end
end

