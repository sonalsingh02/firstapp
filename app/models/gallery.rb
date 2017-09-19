class Gallery < ApplicationRecord
  require 'csv'
  belongs_to :user
  validates :name, presence: true, uniqueness: true
  has_attached_file :image, styles: { small: "64x64", med: "100x100", large: "200x200" },
                            :url  => "/assets/products/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  paginates_per  2

  def self.import(file)
    @errors = []
    CSV.foreach(file.path, headers: true) do |row|
      Rails.logger.info("in for each")
      begin
        gallery = Gallery.new(row.to_hash)
        Rails.logger.info(gallery)
        if !gallery.save
          Rails.logger.info("NOT SAVED")
          gallery.errors.full_messages.each do |message|
           # Rails.logger.info(message)
            @errors << "#{message}"
            Rails.logger.info(@errors.inspect)
          end
        end
      rescue SocketError => details    # or the Exception class name may be SocketError  
        @errors << "Failed to load the data: #{details}"
        return @errors
      end
    end
    return @errors
  end
end