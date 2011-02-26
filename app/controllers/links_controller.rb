class LinksController < ApplicationController
  before_filter :get_link, :only => [:edit, :update, :destroy]

  def new
    @link = Link.new
    @link.note = Note.find(params[:note]) if params[:note]
    @link.evensong = Evensong.find(params[:evensong]) if params[:evensong]
  end

  def create
    @link = Link.new(params[:link])

    if @link.save
      flash[:notice] = "Lenke lagret"
      if (@link.note)
        redirect_to note_path(@link.note)
      else
        redirect_to evensong_path(@link.evensong)
      end
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @link.title = params["link"]["title"]
    @link.url = params["link"]["url"]

    if @link.save
      flash[:notice] = "Lenke lagret"
      if (@link.note)
        redirect_to note_path(@link.note)
      else
        redirect_to evensong_path(@link.evensong)
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    if (@link.note)
      redirect_path = note_path(@link.note)
    else
      redirect_path = evensong_path(@link.evensong)
    end

    @link.destroy

    redirect_to redirect_path
  end

  private

  def get_link
    @link = Link.find(params[:id])
  end
end
