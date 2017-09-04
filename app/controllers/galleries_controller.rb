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
    #validate data of csv if headers are valid
    @row = []
    @import_count = 0
    @failed_import = 0
    @failed_format = 0
    CSV.foreach(@file,encoding:'iso-8859-1:utf-8', col_sep: ';') do |row|
      @row << row
    end
    if @row.length > 1 && !@errors.any?# data exists more than header
      @row.each_with_index do |row, index|
        next if index == 0
        @errors = validate_csv_data(row,index)
        if !@errors.present?
          params = row.first.split(",")
          begin
            @gallery = @user.galleries.build(name: params[0], image: params[1])
          rescue
            
          end
          begin
            if @gallery.save
              @import_count += 1
            end
          rescue 
            Rails.logger.info("EXCEPTION")
            @failed_import += 1
          end
        else
          @failed_format +=1
        end
      end
    else
     @errors << "Content is missing"
    end
    if @errors.present?
      respond_to do |format|
        format.js
      end
    else
      if @import_count >= 1 && @failed_import >= 1 && @failed_format >= 1
        @msg = "#{@import_count} rows are imported sucessfully , #{@failed_import} rows could not be imported as the file is missing and #{@failed_format} rows could not be validated and imported"
      elsif @failed_import >= 1 && @import_count >= 1 && @failed_format == 0
        @msg = "#{@import_count} rows are imported sucessfully , #{@failed_import} rows could not be imported as the file is missing"
      elsif @import_count >= 1 && @failed_import == 0 && @failed_format == 0
        Rails.logger.info("edgtedfedsfesfewsfs")
        @msg = "#{@import_count} rows are imported sucessfully"
      end
      redirect_to user_galleries_url(@user), notice: "#{@msg}"
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
    allowed_attributes = %w(name image)
    @errors = []
    @headers = CSV.open(@file,'r') { |csv| csv.first } #To find first row of csv file i.e. header
    # check if headers are valid
    if @headers && !@headers.empty? # check if headers are present
      @headers = CSV.read(@file).flatten
      if CSV.read(@file).count == 2
        count = allowed_attributes.count - @headers.count
        if count > 0
          #in this case either name is missing or image is missing or both
          if allowed_attributes[0].downcase != @headers[0].try(:downcase) && allowed_attributes[1].downcase != @headers[1].try(:downcase)
              @errors << "Both Headers are missing"
          end
          if allowed_attributes[0].downcase != @headers[0].try(:downcase)
              @errors << "Header 'name' is missing or written in incorrect postition or not spelled correctly"
          end
          if allowed_attributes[1].downcase != @headers[1].try(:downcase)
              @errors << "Header 'image' is missing or written in incorrect postition or not spelled correctly"
          end
        end
        if count < 0
          #in this case we will check if header data is proper or not
          if allowed_attributes[0].downcase != @headers[0].try(:downcase)
            @errors << "Header 'name' is missing or written in incorrect postition or not spelled correctly"
          end
          if allowed_attributes[1].downcase != @headers[1].try(:downcase)
            @errors << "Header 'image' is missing or written in incorrect postition or not spelled correctly"
          end
        end
        if count > 0
          #in this case either name is missing or image is missing or both
          if allowed_attributes[0].downcase != @headers[0].try(:downcase) && allowed_attributes[1].downcase != @headers[1].try(:downcase)
            @errors << "Both Headers are missing"
          end
          if allowed_attributes[0].downcase != @headers[0].try(:downcase)
            @errors << "Header 'name' is missing or written in incorrect postition or not spelled correctly"
          end
          if allowed_attributes[1].downcase != @headers[1].try(:downcase)
            @errors << "Header 'image' is missing or written in incorrect postition or not spelled correctly"
          end
        end
      elsif CSV.read(@file).count > 2
        count = allowed_attributes.count - @headers.count
        if count > 0
          #in this case either name is missing or image is missing or both
          if allowed_attributes[0].downcase != @headers[0].try(:downcase) && allowed_attributes[1].downcase != @headers[1].try(:downcase)
              @errors << "Both Headers are missing"
          end
          if allowed_attributes[0].downcase != @headers[0].try(:downcase)
              @errors << "Header 'name' is missing or written in incorrect postition or not spelled correctly"
          end
          if allowed_attributes[1].downcase != @headers[1].try(:downcase)
              @errors << "Header 'image' is missing or written in incorrect postition or not spelled correctly"
          end
        end
        if count < 0
          #in this case we will check if header data is proper or not
          if allowed_attributes[0].downcase != @headers[0].try(:downcase)
            @errors << "Header 'name' is missing or written in incorrect postition or not spelled correctly"
          end
          if allowed_attributes[1].downcase != @headers[1].try(:downcase)
            @errors << "Header 'image' is missing or written in incorrect postition or not spelled correctly"
          end
        end
        if count > 0
          #in this case either name is missing or image is missing or both
          if allowed_attributes[0].downcase != @headers[0].try(:downcase) && allowed_attributes[1].downcase != @headers[1].try(:downcase)
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
        count = allowed_attributes.count - @headers.count
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
        @errors << "CSV file is empty"
      else
        @errors << "CSV file is empty"
      end
    else
      @errors << "CSV file is empty"
    end
    @errors
  end

  def all_letters_or_digits(str)
    str[/[a-zA-Z0-9]+/]  == str
  end

  def validate_name(row, row_num)
    unless row[0].empty?
      if !all_letters_or_digits(row[0])
        @errors << "In Row no #{row_num} : Name should contain letters or digits only!"
      end
    else
      @errors << "In Row no #{row_num} : Name is missing!"
    end
  end

  def validate_url?(string)
     Rails.logger.info(string)
    if string =~ URI::regexp
      true
    else
      false
    end
  end

  def validate_image(row, row_num)
    unless row[1].empty?
      if validate_url?(row[1])
        return true
      else
        @errors << "In Row no #{row_num} : Image URL is incorrect"
        return false
      end
    else
      @errors << "In Row no #{row_num} : Image URL is missing!"
    end
  end

  def check_value(row,row_num)
    unless row[0].empty?
       if !all_letters_or_digits(row[0])
          @errors << "In Row no #{row_num} : Name should contain only letters and digits"
        end
        if !validate_url?(row[0])
          @errors << "In Row no #{row_num} : Image URL is incorrect"
        end
    end
  end

  #validation of data in a csv file
  def validate_csv_data(row,index)
    if row.any? && !row.empty?
      row = row.first.split(",")
      if @row.length  == 2
        if row.length == 1 # if true that means either name data is missing or image data is missing
          check_value(row,index+1)
        end
        if row.length == 2
          validate_name(row,index+1)
          validate_image(row,index+1)
        end
        if row.length > 2
          @errors << "Data is more than what is expected"
        end
      elsif @row.length  > 2
        if row.length == 1 # if true that means either name data is missing or image data is missing
          check_value(row,index+1)
        end
        if row.length == 2
          validate_name(row,index+1)
          validate_image(row,index+1)
        end
        if row.length > 2
          @errors << "Data is more than what is expected"
        end
      else
        @errors << "Content is missing"
      end
    else
      @errors << "Content is missing"
    end
  end
end