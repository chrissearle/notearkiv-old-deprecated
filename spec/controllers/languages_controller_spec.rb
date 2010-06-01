require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LanguagesController do
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
      Language.should_receive(:new)
      get :new
    end
  end

  describe "GET edit" do
    it "should respond" do
      @language = mock_model(Language)
      Language.stub(:find).and_return(@language)
      get :edit, :id => 1
      assigns[:language].should == @language
    end
  end

  describe "POST create" do
    before(:each) do
      @language = mock_model(Language, :save => nil)
      Language.stub(:new).and_return(@language)
    end

    it "creates a new language" do
      Language.should_receive(:new).with("name" => "test language")
      post :create, :language => {"name" => "test language"}
    end

    it "saves the language" do
      @language.should_receive(:save)
      post :create
    end

    context "when the language saves successfully" do
      before(:each) do
        @language.stub(:save).and_return(true)
      end

      it "sets a flash[:notice] message" do
        post :create
        flash[:notice].should == "Språk opprettet."
      end

      it "redirects to the languages index" do
        post :create
        response.should redirect_to(languages_path)
      end
    end

    context "when the language fails to save" do
      before(:each) do
        @language.stub(:save).and_return(false)
      end

      it "assigns @language" do
        post :create
        assigns[:language].should == @language
      end

      it "renders the new template" do
        post :create
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @language = mock_model(Language, :save => nil)
      Language.stub(:find).and_return(@language)
      @language.stub(:name=)
    end

    it "saves the language" do
      @language.should_receive(:save)
      put :update, :id => 1, :language => {"name" => "New name"}
    end

    context "when the language saves successfully" do
      before(:each) do
        @language.stub(:save).and_return(true)
      end

      it "sets a flash[:notice] message" do
        put :update, :id => 1, :language => {"name" => "New name"}
        flash[:notice].should == "Språk oppdatert."
      end

      it "redirects to the languages index" do
        put :update, :id => 1, :language => {"name" => "New name"}
        response.should redirect_to(languages_path)
      end
    end

    context "when the language fails to save" do
      before(:each) do
        @language.stub(:save).and_return(false)
      end

      it "assigns @language" do
        put :update, :id => 1, :language => {"name" => "New name"}
        assigns[:language].should == @language
      end

      it "renders the edit template" do
        put :update, :id => 1, :language => {"name" => "New name"}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @language = mock_model(Language, :save => nil)
      Language.stub(:find).and_return(@language)
      @language.stub(:name).and_return("Test Language")
    end

    it "destroys the language" do
      @language.should_receive(:destroy)

      delete :destroy, :id => 1
    end

    context "when the language is deleted" do
      before(:each) do
        @language.should_receive(:destroy)
      end

      it "sets a flash[:notice] message" do
        delete :destroy, :id => 1

        flash[:notice].should == "Språk Test Language slettet."
      end

      it "redirects to the languages index" do
        delete :destroy, :id => 1

        response.should redirect_to(languages_path)
      end
    end
  end
end
