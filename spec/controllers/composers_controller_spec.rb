# coding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ComposersController do
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
      Composer.should_receive(:new)
      get :new
    end
  end

  describe "GET edit" do
    it "should respond" do
      @composer = mock_model(Composer)
      Composer.stub(:find).and_return(@composer)
      get :edit, :id => 1
      assigns[:composer].should == @composer
    end
  end

  describe "POST create" do
    before(:each) do
      @composer = mock_model(Composer, :save => nil)
      Composer.stub(:new).and_return(@composer)
    end

    it "creates a new composer" do
      Composer.should_receive(:new).with("name" => "test composer")
      post :create, :composer => {"name" => "test composer"}
    end

    it "saves the composer" do
      @composer.should_receive(:save)
      post :create
    end

    context "when the composer saves successfully" do
      before(:each) do
        @composer.stub(:save).and_return(true)
      end

      it "sets a flash[:notice] message" do
        post :create
        flash[:notice].should == "Komponist opprettet."
      end

      it "redirects to the composers index" do
        post :create
        response.should redirect_to(composers_path)
      end
    end

    context "when the composer fails to save" do
      before(:each) do
        @composer.stub(:save).and_return(false)
      end

      it "assigns @composer" do
        post :create
        assigns[:composer].should == @composer
      end

      it "renders the new template" do
        post :create
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @composer = mock_model(Composer, :save => nil)
      Composer.stub(:find).and_return(@composer)
      @composer.stub(:name=)
    end

    it "saves the composer" do
      @composer.should_receive(:save)
      put :update, :id => 1, :composer => {"name" => "New name"}
    end

    context "when the composer saves successfully" do
      before(:each) do
        @composer.stub(:save).and_return(true)
      end

      it "sets a flash[:notice] message" do
        put :update, :id => 1, :composer => {"name" => "New name"}
        flash[:notice].should == "Komponist oppdatert."
      end

      it "redirects to the composers index" do
        put :update, :id => 1, :composer => {"name" => "New name"}
        response.should redirect_to(composers_path)
      end
    end

    context "when the composer fails to save" do
      before(:each) do
        @composer.stub(:save).and_return(false)
      end

      it "assigns @composer" do
        put :update, :id => 1, :composer => {"name" => "New name"}
        assigns[:composer].should == @composer
      end

      it "renders the edit template" do
        put :update, :id => 1, :composer => {"name" => "New name"}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @composer = mock_model(Composer, :save => nil)
      Composer.stub(:find).and_return(@composer)
      @composer.stub(:name).and_return("Test Composer")
    end

    it "destroys the composer" do
      @composer.should_receive(:destroy)

      delete :destroy, :id => 1
    end

    context "when the composer is deleted" do
      before(:each) do
        @composer.should_receive(:destroy)
      end

      it "sets a flash[:notice] message" do
        delete :destroy, :id => 1

        flash[:notice].should == "Komponist Test Composer slettet."
      end

      it "redirects to the composers index" do
        delete :destroy, :id => 1

        response.should redirect_to(composers_path)
      end
    end
  end
end
