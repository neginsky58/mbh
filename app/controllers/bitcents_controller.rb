require 'net/http'
require 'open-uri'	

class BitcentsController < ApplicationController
	
	def index
		@bitcents = Bitcents.find(:all)

		respond_to do |format|	      
	      format.html # index.html.erb
	      format.xml
	    end
	end

	def buy_pixels
		
		@pos_x = params[:pos_x].nil? ? 0:params[:pos_x].to_i
		@pos_y = params[:pos_y].nil? ? 0:params[:pos_y].to_i
		@rect_width = params[:rect_width].nil? ? 0:params[:rect_width].to_i
		@rect_height = params[:rect_height].nil? ? 0:params[:rect_height].to_i

		respond_to do |format|	      			
	    	format.html
	    	format.xml
	    end
	end

	def pay_pixels		
		@pos_x = params[:pos_x].nil? ? 0:params[:pos_x].to_i
		@pos_y = params[:pos_y].nil? ? 0:params[:pos_y].to_i
		@rect_width = params[:rect_width].nil? ? 0:params[:rect_width].to_i
		@rect_height = params[:rect_height].nil? ? 0:params[:rect_height].to_i
		respond_to do |format|
			if params[:avatar].nil? || params[:avatar].blank?
				flash[:error] = 'Empty image uploaded.'
			end
			if params[:custom_text].nil? || params[:custom_text].blank?
				flash[:error] = 'Empty Custom Text.'
			end
			if params[:custom_link].nil? || params[:custom_link].blank?
				flash[:error] = 'Empty Custom Link.'
			end
			@image = Images.create(:file => params[:avatar])
			
			save_data = {
				:x => @pos_x,
				:y => @pos_y,
				:width => @rect_width,
				:height => @rect_height,
				:title => params[:custom_text],
				:link => params[:custom_link],
				:image_id => @image.id
			}

			@total_amouts = @rect_width * @rect_height
			@bitcent = Bitcents.create(save_data)

			@return_note = @bitcent.id.to_s

			@uri_str = "https://inputs.io/api?key=" << INPUTS_IO_API_KEY << "&action=receive&address=" << params[:bitcoin_addr] << "&amount=" << @total_amouts.to_s << "&note=" << @return_note

			puts '=== DEBUG === Str ==='
			puts @uri_str
			uri = URI(@uri_str)
			res = Net::HTTP.get_response(uri)
			puts '=== DEBUG === inputs.io/api - Response ==='
			puts res.body if res.is_a?(Net::HTTPSuccess)

			#response = Net::HTTP.get_response("example.com","/?search=thing&format=json")
			#puts response.body //this must show the JSON contents

			format.html { redirect_to thank_you_path }
			format.xml
		end
	end

	def do_payment
		@ref_id = params[:ref_id]
		@amount = params[:amount]
		respond_to do |format|
			format.html
			format.json
		end
	end

	def thank_you

	end
	
	def bitcoin_callback
		@remote_ip = request.remote_ip
		@note = params[:note].nil? ? '0':params[:note]
		@amount = params[:amount].nil? ? '0':params[:amount]
		@from = params[:from].nil? ? '':params[:from]
		@from = URI::encode(@from)
		@note = URI::encode(@note)

		puts '=== IP Addr: ', @remote_ip.inspect
		#if @remote_ip[0..8] == "64.22.68."
			if @note[0..5] == "Error:"
				save_data = {
					:ip_addr => @remote_ip,
					:amount => @amount.to_i,
					:is_paid => false,
					:from => @from,
					:error => @note
				}
				@payment = Payments.create(save_data)
			else				
				save_data = {
					:bitcent_id => @note.to_i,
					:amount => @amount.to_i,
					:is_paid => true,
					:ip_addr => @remote_ip,
					:from => @from
				}
				@payment = Payments.create(save_data)
				puts 'DEBUG2: ', @payment.inspect
			end
		#end
	end

	# ajax function
	def validate_rect 

		@pos_x = params[:pos_x]
		@pos_y = params[:pos_y]
		@rect_width = params[:rect_width]
		@rect_height = params[:rect_height]
		rlt = is_available(@pos_x.to_i, @pos_y.to_i, @rect_width.to_i, @rect_height.to_i)
		respond_to do |format|	      
	    	format.json { render :json => { :is_available => rlt } }
	    end

	end

	def is_available(x, y, width, height)
		@bitcents = Bitcents.find(:all)
		rlt = true

		@bitcents.each do |bitcent|			
			conflicted = is_conflict(x, y, width, height, bitcent.x, bitcent.y, bitcent.width, bitcent.height)
			puts x, y, width, height, bitcent.x, bitcent.y, bitcent.width, bitcent.height, conflicted
			if conflicted
				rlt = false
				break 
			end
		end
		return rlt
	end

	def is_conflict(x1, y1, width1, height1, x2, y2, width2, height2)
		min_x = x1
		if x2 < x1
			min_x = x2
		end
		min_y = y1
		if y2 < y1 
			min_y = y2
		end
		max_x = x2 + width2
		if x2 + width2 < x1 + width1
			max_x = x1 + width1
		end
		max_y = y2 + height2
		if y2 + height2 < y1 + height1
			max_y = y1 + height1
		end

		if max_x - min_x < width1 + width2 and max_y - min_y < height1 + height2 
			rlt = true
		else
			rlt = false
		end
		rlt
	end

	# Debug action
	def check_database
		@payments = Payments.all
	end


end
