class Api::V1::GalleryPicturesController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:upload,:retrieve]
  before_action :find_user
  
  def upload
    @errors = []
    if @errors.empty?
      if !@user.nil?
        validate_params_for_upload(upload_params)
        if @errors.empty?
          gallery = @user.galleries.build(upload_params)
          if gallery.save
            render json: { :status => "Success", :message => "Successful", :code => 200 }
          else
            render json: { :status => "Failure", :message => gallery.errors.full_messages, :code => 500 }
          end
        else
          if @errors.length == 1
            render json: { :status => "Failure", :message => @errors, :code => 500 }
          elsif @errors.length > 1
            message = ""
            @errors.each do |e|
              message += e + ";"
            end
           render json: { :status => "Failure", :message => message, :code => 500 }
          end
        end
      else
        render json: { :status => "Failure", :message => "User doesn't exist", :code => 500 }
      end
    else
      ender json: { :status => "Failure", :message => "User id is empty", :code => 500 }
    end
  end

  def retrieve
    @errors = []
    if @errors.empty?
      if !@user.nil?
        validate_params_for_retrieve(params[:id],params[:user_id]) #validations to check if data is proper
        gallery = @user.galleries.find_by(id: params[:id],user_id: params[:user_id])
        if gallery
          data = { name: gallery.name, image: gallery.image }
          render json: { :status => "Success", :message => 'Successful', :data => data, :code => 200}
        else
          render json: { :status => "Failure", :message => "Gallery doesn't exist", :code => 500}
        end
      else
        render json: { :status => "Failure", :message => "Gallery doesn't exist", :code => 500 }
      end
    else
      if @errors.length == 1
        render json: { :status => "Failure", :message => @errors, :code => 500 }
      else
        message = ""
        @errors.each do |e|
          message += e + ";"
        end
        render json: { :status => "Failure", :message => message, :code => 500 }
      end
    end
  end

  private

  def all_letters_or_digits(str)
    str[/[a-zA-Z0-9]+/]  == str
  end

  def all_digits(value)
    value.is_a? Numeric
  end

  def validate_url?(string)
     Rails.logger.info(string)
    if string =~ URI::regexp
      true
    else
      false
    end
  end

  def find_user
    @errors =[]
    if params[:user_id] != ""
      if !all_digits(params[:user_id])
        @errors << "User Id should be digit"
      else
        @user = User.find_by(id: params[:user_id])
      end
    else
      @errors << "User Id is empty"
    end
  end

  def upload_params
    params.require(:gallery_picture).permit(
      :name, :image, :user_id
    )
  end

  def validate_params_for_upload params
    if params[:name] != ""
      if !all_letters_or_digits(params[:name])
        @errors << "Name should have alphabets and digits only"
      end
    else
       @errors << "Name is empty"
    end
    if params[:image] != ""
      if !validate_url?(params[:image])
        @errors << "Image URL is incorrect"
      end
    else
      @errors << "Image URL is empty"
    end
  end

  def validate_params_for_retrieve params
    if params[:id] != ""
       if !all_digits(params[:id])
        @errors << "Id should be digit"
      end
    else
       @errors << "Id is empty"
    end
  end

end