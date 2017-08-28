class GalleriesController < ApplicationController
  before_action :find_current_user
  before_action :find_gallery, only: [:edit, :update]

  def index
    @galleries = @user.galleries.page(params[:page]).order('created_at DESC').per(2)
  end

  def new
    @gallery = @user.galleries.build
    Rails.logger.info("#{@gallery}")
    respond_to do |format|
      format.js
    end
  end

  def create
    @gallery = @user.galleries.build(gallery_params)
    if @gallery.save
      @galleries = @user.galleries.page(params[:page]).order('created_at DESC').per(2)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js { render 'new'}
      end
    end
  end

  def edit;
  end

  def update
    if @gallery.update_attributes(gallery_params)
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js { render 'edit'}
      end
    end
  end

  def check_name
    @gallery = @user.galleries.find_by(name: params[:gallery][:name])
    respond_to do |format|
      format.json { render json: !@gallery }
    end
  end

  def import_csv_form
    respond_to do |format|
      format.js
    end
  end

  def import
    @user.galleries.import(params[:file])
    redirect_to user_galleries_url(@user), notice: "Galleries are imported successfully."
  end

  private

  def gallery_params
    params.require(:gallery).permit(
      :name, :image, :user_id
    )
  end

  def find_current_user
    @user = current_user
  end

  def find_gallery
    @gallery = @user.galleries.find_by(id: params[:id])
  end
end
