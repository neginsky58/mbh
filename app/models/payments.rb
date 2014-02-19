class Payments < ActiveRecord::Base
	attr_accessible :sid, :bitcent_id, :amount, :is_paid, :error, :from, :ip_addr
end
