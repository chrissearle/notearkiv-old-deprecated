# coding: UTF-8
=begin

For this set of tests to run - we need to find how to handle the calles to current_user in the controller

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountController do
  before(:each) do
    Authorization.ignore_access_control(true)
  end

  describe "GET index" do
    it "should respond" do
      get :index
    end
  end

  describe "GET edit" do
    it "should respond" do
      user = mock_model(User)
      User.stub(:find_by_username).and_return(user)
      get :edit, :id => 1
      assigns[:user].should == user
    end
  end

  describe "PUT update" do
    before(:each) do
      @user = mock_model(User, :save => nil)
      User.stub(:find_by_username).and_return(@user)
      @user.stub(:email=)
      @user.stub(:password=)
      @user.stub(:password_confirmation=)
    end

    it "saves the user" do
      @user.should_receive(:save)
      put :update, :id => 1, :user => {"email" => "email@example.com"}
    end

    context "when the user saves successfully" do
      before(:each) do
        @user.stub(:save).and_return(true)
      end

      it "sets a flash[:notice] message" do
        put :update, :id => 1, :user => {"email" => "email@example.com"}
        flash[:notice].should == "Bruker oppdatert."
      end

      it "redirects to the users index" do
        put :update, :id => 1, :user => {"email" => "email@example.com"}
        response.should redirect_to(users_path)
      end
    end

    context "when the user fails to save" do
      before(:each) do
        @user.stub(:save).and_return(false)
      end

      it "assigns @user" do
        put :update, :id => 1, :user => {"email" => "email@example.com"}
        assigns[:user].should == @user
      end

      it "renders the edit template" do
        put :update, :id => 1, :user => {"email" => "email@example.com"}
        response.should render_template("edit")
      end
    end
  end
end
=end