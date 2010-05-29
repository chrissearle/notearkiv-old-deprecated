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

  describe "GET new" do
    it "should respond" do
      Genre.should_receive(:new)
      get :new
    end
  end

  describe "GET edit" do
    it "should respond" do
      @genre = mock_model(Genre)
      Genre.stub(:find).and_return(@genre)
      get :edit, :id => 1
      assigns[:genre].should == @genre
    end
  end

  describe "POST create" do
    before(:each) do
      @genre = mock_model(Genre, :save => nil)
      Genre.stub(:new).and_return(@genre)
    end

    it "creates a new genre" do
      Genre.should_receive(:new).with("name" => "salme")
      post :create, :genre => {"name" => "salme"}
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

  describe "PUT update" do
    before(:each) do
      @genre = mock_model(Genre, :save => nil)
      Genre.stub(:find).and_return(@genre)
      @genre.stub(:name=)
    end

    it "saves the genre" do
      @genre.should_receive(:save)
      put :update, :id => 1, :genre => {"name" => "New name"}
    end

    context "when the genre saves successfully" do
      before(:each) do
        @genre.stub(:save).and_return(true)
      end

      it "sets a flash[:notice] message" do
        put :update, :id => 1, :genre => {"name" => "New name"}
        flash[:notice].should == "Genre oppdatert."
      end

      it "redirects to the genres index" do
        put :update, :id => 1, :genre => {"name" => "New name"}
        response.should redirect_to(genres_path)
      end
    end

    context "when the genre fails to save" do
      before(:each) do
        @genre.stub(:save).and_return(false)
      end

      it "assigns @genre" do
        put :update, :id => 1, :genre => {"name" => "New name"}
        assigns[:genre].should == @genre
      end

      it "renders the edit template" do
        put :update, :id => 1, :genre => {"name" => "New name"}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @genre = mock_model(Genre, :save => nil)
      Genre.stub(:find).and_return(@genre)
      @genre.stub(:name).and_return("Test Genre")
    end

    it "destroys the genre" do
      @genre.should_receive(:destroy)

      delete :destroy, :id => 1
    end

    context "when the genre is deleted" do
      before(:each) do
        @genre.should_receive(:destroy)
      end

      it "sets a flash[:notice] message" do
        delete :destroy, :id => 1

        flash[:notice].should == "Genre Test Genre slettet."
      end

      it "redirects to the genres index" do
        delete :destroy, :id => 1

        response.should redirect_to(genres_path)
      end
    end
  end
end
