class API::V1::GalleryPicturesController < ApplicationController
   before_action :find_current_user

  def upload
    @gallery = @user.galleries.build(gallery_params)
    if @gallery.save
      render :json => { :status => "Success", :message => "Successful", :code => 200 }
    else
      render :json => { :status => "Failure", :message => gallery.errors.full_messages, :code => 500 }
    end
  end
 
  def retrieve
   
  end

  private

  def find_current_user
    @user = current_user
  end

  def gallery_params
    params.require(:gallery).permit(
      :name, :image, :user_id
    )
  end
end