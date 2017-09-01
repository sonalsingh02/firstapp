class GalleriesController < ApplicationController
  before_action :find_current_user
  before_action :find_gallery, only: [:edit, :update]
  require 'uri'

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
  # To validate headers in csv file
    @file = params[:file].path
    validate_header
    validate_csv_data if !@errors.any?
    
    if !@errors.any?
      @errors  = @user.galleries.import(params[:file])
      #Rails.logger.info(@errors.inspect)
    end
    if @errors.present?
        # flash[:notice] = nil
        respond_to do |format|
          format.js
        end
    else
      redirect_to user_galleries_url(@user), notice: "Galleries are imported successfully."
    end
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

  #validation of header in a csv file
  def validate_header
    Rails.logger.info("In Header ..................")
    allowed_attributes = %w(name image)
    @file = params[:file].path
    @errors = []
    @headers = CSV.open(@file,'r') { |csv| csv.first } #To find first row of csv file i.e. header
    #############################
    # check if headers are valid
    #Rails.logger.info(@headers.inspect)
    #debugger
    binding.pry
    if @headers && !@headers.empty? # check if headers are present
      binding.pry
      Rails.logger.info("Header is there.................")
      #Rails.logger.info(CSV.read(@file).count)
      @headers = CSV.read(@file).flatten
      Rails.logger.info(".................................")
      Rails.logger.info(CSV.read(@file).count)
      Rails.logger.info(@headers.count)
      Rails.logger.info("..................................")
      if CSV.read(@file).count == 2
        Rails.logger.info("In FIRST CONDITION")
        count = allowed_attributes.count - @headers.count
        #debugger
        if count == 0
          Rails.logger.info("*******************************")
          Rails.logger.info("count is 0")
          Rails.logger.info("*******************************")
          if allowed_attributes[0].downcase != @headers[0].try(:downcase)
              @errors << "Header 'name' is missing or written in incorrect postition or not spelled correctly"
          end
          if allowed_attributes[1].downcase != @headers[1].try(:downcase)
            @errors << "Header 'image' is missing or written in incorrect postition or not spelled correctly"
          end
        end
        if count < 0
          Rails.logger.info("*******************************")
          Rails.logger.info("count < 0")
          Rails.logger.info("*******************************")
          #in this case we will check if header data is proper or not
          if allowed_attributes[0].downcase != @headers[0].try(:downcase) 
              @errors << "Header 'name' is missing or written in incorrect postition or not spelled correctly"
          end
          if allowed_attributes[1].downcase != @headers[1].try(:downcase)
              @errors << "Header 'image' is missing or written in incorrect postition or not spelled correctly"
          end
        end
        if count > 0
          Rails.logger.info("*******************************")
          Rails.logger.info("count > 0")
          Rails.logger.info("*******************************")
          #in this case either name is missing or image is missing or both
          if allowed_attributes[0].downcase != @headers[0].try(:downcase) && if allowed_attributes[1].downcase != @headers[1].try(:downcase)
              @errors << "Both Headers are missing"
          end
          if allowed_attributes[0].downcase != @headers[0].try(:downcase)
              @errors << "Header 'name' is missing or written in incorrect postition or not spelled correctly"
          end
          if allowed_attributes[1].downcase != @headers[1].try(:downcase)
              @errors << "Header 'image' is missing or written in incorrect postition or not spelled correctly"
          end
        end
      elsif CSV.read(@file).count == 1 #only one row exists
        binding.pry
        Rails.logger.info("In SECOND CONDITION")
        count = allowed_attributes.count - @headers.count
        Rails.logger.info("Header***************************")
        Rails.logger.info(@headers[0])
        Rails.logger.info("*******************************")
        Rails.logger.info("count***************************")
        Rails.logger.info(count)
        Rails.logger.info("*******************************")
        if count == 0
          if allowed_attributes[0].downcase != @headers[0].try(:downcase) && allowed_attributes[1].downcase != @headers[1].try(:downcase)
              @errors << "Both Headers are missing or written in incorrect postition or not spelled correctly"
          end
          if allowed_attributes[0].downcase != @headers[0].try(:downcase)
              @errors << "Header 'name' is missing or written in incorrect postition or not spelled correctly"
          end
          if allowed_attributes[1].downcase != @headers[1].try(:downcase)
              @errors << "Header 'image' is missing or written in incorrect postition or not spelled correctly"
          end
        end
        if count > 0 #less than what is expected
          if @headers[0] && @headers[1] && allowed_attributes[0].downcase != @headers[0].try(:downcase) && allowed_attributes[1].downcase != @headers[1].try(:downcase)
                @errors << "Both Headers are missing or written in incorrect postition or not spelled correctly"
          end
          if @headers[0] && allowed_attributes[0].downcase != @headers[0].try(:downcase)
              @errors << "Header 'name' is missing or written in incorrect postition or not spelled correctly"
          end
          if @headers[0] && allowed_attributes[1].downcase != @headers[0].try(:downcase)
              @errors << "Header 'image' is missing or written in incorrect postition or not spelled correctly"
          end
        end
        if count < 0 #more than what is expected
            @errors << "Headers more than what is expected"
        end
      elsif CSV.read(@file).count == 0 #no row exists
        Rails.logger.info("In THIRD CONDITION")
        Rails.logger.info("in count  == 0")
        #Rails.logger.info(@headers[0])
        @errors << "CSV file is empty"
      else
        Rails.logger.info("elseeeee")
        Rails.logger.info(@headers.inspect)
        @errors << "CSV file is empty"
      end
    else
      binding.pry
      # Rails.logger.info("elseeeee")
      
      Rails.logger.info "dsjfjkshfkjsh #{@headers.inspect}"
      @errors << "CSV file is empty"
    end
    @errors
  end

  def all_letters_or_digits(str)
    str[/[a-zA-Z0-9]+/]  == str
  end

  def validate_name(row, row_num)
    Rails.logger.info("*******************************")
    Rails.logger.info("in validate name")
     Rails.logger.info("*******************************")
    #Rails.logger.info(row[0])
    unless row[0].empty?
      if !all_letters_or_digits(row[0])
        Rails.logger.info("in validate name")
        #Rails.logger.info(row[0])
        @errors << "In Row no #{row_num} : Name should contain letters or digits only"
      end
    end
  end

  def validate_url?(string)
    uri = URI.parse(string)
    rescue URI::BadURIError
      false
    rescue URI::InvalidURIError
      false
    end
  end

  def validate_image(row, row_num)
    #Rails.logger.info("in validate image")
    #Rails.logger.info(validate_url?(row[0]))
    unless row[0].empty?
      @errors << "In Row no #{row_num} : Image URL is incorrect" unless validate_url?(row[0])
    end
  end

  def check_value(row,row_num)
    unless row[0].empty?
       if !all_letters_or_digits(row[0])
          @errors << "In Row no #{row_num} : Name should contain only letters and didgits"
        end
        if !validate_url?(row[0])
          @errors << "In Row no #{row_num} : URL is not correct"
        end
    end
  end

  #validation of data in a csv file
  def validate_csv_data

    @row = []
     Rails.logger.info("*******index*********")
      Rails.logger.info("in validate csv")
      Rails.logger.info("*******row *********")
    CSV.foreach(@file,encoding:'iso-8859-1:utf-8', col_sep: ';') do |row|
      @row << row
    end
    #Rails.logger.info("*******ROW LENGTH*********")
    #Rails.logger.info(@row.length)
    #Rails.logger.info("*******ROW LENGTH *********")
    if @row.length > 1 # data exists more than header
      @row.each_with_index do |row, index|
        next if index == 0
        if row.any? && !row.empty?
          row = row.first.split(",")
          if @row.length  == 2 #if true that means import data exists
            if row.length == 1 # if true that means either name data is missing or image data is missing
              check_value(row,index+1)
            elsif row.length == 2
              validate_name(row,index+1)
              validate_image(row,index+1)
            elsif row.length > 2
              @errors << "Data is more than what is expected"
            end
          end
        else
           Rails.logger.info("MISSSING")
           @errors << "Content is missing"
        end
      end
    else
      Rails.logger.info("MISSSING")
      @errors << "Content is missing"
    end 
  end  
end
                                                                                                                                                  
