class UsersController < ApplicationController
  filter_access_to :all

  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @users }
    end
  end

end
