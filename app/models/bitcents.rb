class Bitcents < ActiveRecord::Base

	attr_accessible :x, :y, :width, :height, :title, :link, :image_id

	belongs_to :image, :foreign_key => "image_id", :class_name => "Images"
end

