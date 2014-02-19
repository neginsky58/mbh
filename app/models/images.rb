class Images < ActiveRecord::Base
	attr_accessible :file 
	
	has_attached_file :file, 
		storage: :dropbox,
		dropbox_credentials: Rails.root.join("config/dropbox.yml"),
		default_url: "assets/missing.png",
		hash_secret: "19DKW32K1023K3I2LS0EK293@3342!A23WERW212W",		
		path: "upload/:hash.:extension"	

	has_many :bitcents, :class_name => 'Bitcents'
	
end
