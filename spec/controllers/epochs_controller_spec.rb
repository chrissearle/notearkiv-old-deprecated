# coding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PeriodsController do
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
      Period.should_receive(:new)
      get :new
    end
  end

  describe "GET edit" do
    it "should respond" do
      @epoch = mock_model(Period)
      Period.stub(:find).and_return(@epoch)
      get :edit, :id => 1
      assigns[:period].should == @epoch
    end
  end

  describe "POST create" do
    before(:each) do
      @epoch = mock_model(Period, :save => nil)
      Period.stub(:new).and_return(@epoch)
    end

    it "creates a new epoch" do
      Period.should_receive(:new).with("name" => "test period")
      post :create, :period => {"name" => "test period"}
    end

    it "saves the epoch" do
      @epoch.should_receive(:save)
      post :create
    end

    context "when the epoch saves successfully" do
      before(:each) do
        @epoch.stub(:save).and_return(true)
      end

      it "sets a flash[:notice] message" do
        post :create
        flash[:notice].should == "Epoke opprettet."
      end

      it "redirects to the epochs index" do
        post :create
        response.should redirect_to(periods_path)
      end
    end

    context "when the epoch fails to save" do
      before(:each) do
        @epoch.stub(:save).and_return(false)
      end

      it "assigns @epoch" do
        post :create
        assigns[:period].should == @epoch
      end

      it "renders the new template" do
        post :create
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @epoch = mock_model(Period, :save => nil)
      Period.stub(:find).and_return(@epoch)
      @epoch.stub(:name=)
    end

    it "saves the epoch" do
      @epoch.should_receive(:save)
      put :update, :id => 1, :period => {"name" => "New name"}
    end

    context "when the epoch saves successfully" do
      before(:each) do
        @epoch.stub(:save).and_return(true)
      end

      it "sets a flash[:notice] message" do
        put :update, :id => 1, :period => {"name" => "New name"}
        flash[:notice].should == "Epoke oppdatert."
      end

      it "redirects to the epochs index" do
        put :update, :id => 1, :period => {"name" => "New name"}
        response.should redirect_to(periods_path)
      end
    end

    context "when the epoch fails to save" do
      before(:each) do
        @epoch.stub(:save).and_return(false)
      end

      it "assigns @epoch" do
        put :update, :id => 1, :period => {"name" => "New name"}
        assigns[:period].should == @epoch
      end

      it "renders the edit template" do
        put :update, :id => 1, :period => {"name" => "New name"}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @epoch = mock_model(Period, :save => nil)
      Period.stub(:find).and_return(@epoch)
      @epoch.stub(:name).and_return("Test Period")
    end

    it "destroys the epoch" do
      @epoch.should_receive(:destroy)

      delete :destroy, :id => 1
    end

    context "when the epoch is deleted" do
      before(:each) do
        @epoch.should_receive(:destroy)
      end

      it "sets a flash[:notice] message" do
        delete :destroy, :id => 1

        flash[:notice].should == "Epoke Test Period slettet."
      end

      it "redirects to the epochs index" do
        delete :destroy, :id => 1

        response.should redirect_to(periods_path)
      end
    end
  end
end
