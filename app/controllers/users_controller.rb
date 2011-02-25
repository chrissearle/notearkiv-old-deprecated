# coding: UTF-8

class UsersController < ApplicationController
  filter_access_to :all

  before_filter :get_user, :only => [:edit, :show, :update]

  def index
    @users = User.all
  end

  def edit
  end

  def show
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Bruker oppdatert.'
      redirect_to :action => "index"
    else
      render :action => "edit"
    end
  end

  private

  def get_user
    @user = User.find(params[:id])
  end

end
