class Api::V1::GalleryPicturesController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:upload,:retrieve]
  before_action :find_user
  
  def upload
    if !@user.nil?
      gallery = @user.galleries.build(upload_params)
      if gallery.save
        render json: { status: "Success", message: "Successful", code: 200 }
      else
        render json: { status: "Failure", message: gallery.errors.full_messages, code: 500 }
      end
    else
       render json: { status: "Failure", message: gallery.errors.full_messages, code: 500 }
    end
  end

  def retrieve
    if !@user.nil?
      gallery = @user.galleries.find_by(id: params[:id],user_id: params[:user_id])
      if gallery
        data = { name: gallery.name, image: gallery.image }
        render json: { :status => "Success", :message => 'Successful', :data => data, :code => 200}
      else
        render json: { :status => "Failure", :message => "Gallery doesn't exist", :code => 500}
      end
    else
      render json: { status: "Failure", message: "Gallery doesn't exist", code: 500 }
    end
  end

  private

  def find_user
    @user = User.find_by(id: params[:user_id])
  end

  def upload_params
    params.require(:gallery_picture).permit(
      :name, :image, :user_id
    )
  end
end