class Api::V1::GalleryPicturesController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: [:upload,:retrieve]
  #before_action :find_user_upload, only: [:upload]
  #before_action :find_user_retrieve, only: [:retrieve]
  
  def upload
    @errors = []
    check_key("upload")
    find_user_upload if @errors.empty?
    #Rails.logger.info(@errors.inspect)
    if @errors.empty?
      if !@user.nil?
        validate_params_for_upload(upload_params)
        if @errors.empty?
           validated_params = [] 
           validated_params = upload_params
           #Rails.logger.info("****#{upload_params[:name].strip}*********")
          validated_params[:name] = validated_params[:name].strip
          validated_params[:image] = validated_params[:image].strip
          validated_params[:user_id] = validated_params[:user_id].to_s.strip
          gallery = @user.galleries.build(validated_params)
          if gallery.save
            render json: { :status => "Success", :message => "Image uploaded successfully with id : #{gallery.id}", :code => 200 }
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
        render json: { :status => "Failure", :message => "User doesn't exists", :code => 500 }
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
  end

  def retrieve
    @errors = []
    check_key("retrieve")
    find_user_retrieve if @errors.empty?
    if @errors.empty?
      if !@user.nil?
        #validate_params_for_retrieve(params[:id],params[:gallery_id]) #validations to check if data is proper
        #if @errors.empty?
          gallery = @user.galleries.find_by(id: params[:gallery_id],user_id: params[:id])
          if gallery
            data = { name: gallery.name, image: gallery.image }
            render json: { :status => "Success", :message => 'Image fetched successfully', :data => data, :code => 200}
          else
            render json: { :status => "Failure", :message => "Gallery doesn't exist", :code => 500}
          end
      else
        render json: { :status => "Failure", :message => "User doesn't exists", :code => 500 }
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
    str[/\A[a-zA-Z0-9\s]+\Z/i]  == str
  end

  def all_digits(value)
    value[/\A[0-9]+\Z/i]  == value
  end

  def validate_url?(string)
     Rails.logger.info(string)
    if string =~ URI::regexp
      true
    else
      false
    end
  end

  def find_user_upload
    @errors =[]
    unless params[:user_id].to_s.strip.empty?
      Rails.logger.info(params[:user_id])
      if !all_digits(params[:user_id].to_s.strip)
        @errors << "User Id should be digit"
      else
        @user = User.find_by(id: params[:user_id].to_s.strip)
      end
    else
      @errors << "User Id is empty"
    end
  end

  def find_user_retrieve
    @errors =[]
     unless params[:id].to_s.strip.empty?
       Rails.logger.info(params[:id])
      if !all_digits(params[:id].to_s.strip)
        @errors << "User Id should be digit"
      else
        @user = User.find_by(id: params[:id].to_s.strip)

        unless params[:gallery_id].to_s.strip.empty?
          if !all_digits(params[:gallery_id].to_s.strip)
            @errors << "Gallery Id should be digit"
          end
        else
          @errors << "Gallery Id is empty"
        end
      end
    else
      @errors << "User Id is empty"
    end
     Rails.logger.info(@errors.inspect)
  end

  def upload_params
    params.require(:gallery_picture).permit(
      :name, :image, :user_id
    )
  end

  def validate_params_for_upload params
     unless params[:name].to_s.strip.empty?
      if !all_letters_or_digits(params[:name].to_s.strip)
        @errors << "Name should have alphabets and digits only"
      end
    else
       @errors << "Name is empty"
    end
    unless params[:image].to_s.strip.empty?
      if !validate_url?(params[:image].to_s.strip)
        @errors << "Image URL is incorrect"
      end
    else
      @errors << "Image URL is empty"
    end
  end

  def check_key(check_string)
    if check_string.eql?("upload")
      if(params.has_key?(:name) && params.has_key?(:image) && params.has_key?(:user_id))
        return true
      else
        if(params.has_key?(:name) && !params.has_key?(:image) && !params.has_key?(:user_id))
          @errors << "Image key and User id key is missing"
        elsif(params.has_key?(:name) && params.has_key?(:image) && !params.has_key?(:user_id))
            @errors << "User id key is missing"
        elsif(!params.has_key?(:name) && params.has_key?(:image) && params.has_key?(:user_id))
            @errors << "Name key is missing"
        elsif(!params.has_key?(:name) && params.has_key?(:image) && !params.has_key?(:user_id))
            @errors << "Name key  and User id key is missing"
        elsif(!params.has_key?(:name) && !params.has_key?(:image) && params.has_key?(:user_id))
            @errors << "Name key  and Image id key is missing"
        elsif(params.has_key?(:name) && !params.has_key?(:image) && params.has_key?(:user_id))
            @errors << "Image id key is missing"
        end
        return @errors
      end
    elsif check_string.eql?("retrieve")
      if(!params.has_key?(:id) && !params.has_key?(:gallery_id))
        @errors << "Id key and Gallery Id key is missing"
      elsif(params.has_key?(:id) && !params.has_key?(:gallery_id))
        @errors << "Gallery Id key is missing"
      elsif(!params.has_key?(:id) && params.has_key?(:gallery_id))
        @errors << "Id key is missing"
      end
    end
    Rails.logger.info(@errors.inspect)
  end
end