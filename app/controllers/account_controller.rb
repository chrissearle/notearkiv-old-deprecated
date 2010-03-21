class AccountController < ApplicationController
  def index
    @user = User.find_by_username(current_user.username)

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @user }
    end
  end

  def edit
    @user = User.find_by_username(current_user.username)

    respond_to do |format|
      format.html # edit.html.erb
      format.xml { render :xml => @user }
    end
  end

  def update
    @user = User.find_by_username(current_user.username)

    respond_to do |format|
      @user.email = params["user"]["email"]

      if @user.save
        flash[:notice] = 'Bruker oppdatert.'
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @genre.errors, :status => :unprocessable_entity }
      end
    end
  end
end
