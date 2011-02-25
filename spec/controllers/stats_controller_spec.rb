# coding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe StatsController do
  before(:each) do
    Authorization.ignore_access_control(true)
  end

  describe "GET index" do
    it "should respond and ask for stats" do
      archive_connection = mock_model(ArchiveConnection)
      ArchiveConnection.stub(:new).and_return(archive_connection)
      archive_connection.should_receive(:stats)
      
      get :index
    end
  end
end
