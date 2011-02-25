# coding: UTF-8

class AccountController < ApplicationController
  filter_access_to :all

  before_filter :get_user, :only => [:index, :edit, :update]

  def index
  end

  def edit
  end

  def update
    @user.update_from_user_params params["user"]

    if @user.save
      flash[:notice] = 'Bruker oppdatert.'
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  private

  def get_user
    @user = User.find_by_username(current_user.username)
  end
end
