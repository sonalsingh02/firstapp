class Gallery < ApplicationRecord
  require 'csv'
  belongs_to :user
  validates :name, presence: true
  has_attached_file :image, styles: { small: "64x64", med: "100x100", large: "200x200" },
                            :url  => "/assets/products/:id/:style/:basename.:extension",
                            :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  paginates_per  2

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Gallery.create! row.to_hash
    end
  end
end
