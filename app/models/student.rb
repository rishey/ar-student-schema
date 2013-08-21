require_relative '../../db/config'
require 'date'

class Student < ActiveRecord::Base
	validates :age, numericality: { :greater_than => 4 }
	validates :email, uniqueness: true
	#validates :phone
	validates_format_of :email, :with => /\w+@\w+.\w{2}/
	# validates_numericality_of :phone, :only_integer => true
	#validates_format_of :phone, :with => /^\d{10,}/

	def name
		first_name + " " + last_name
	end

	def age
		 diff = Date.today - birthday
	     age = (diff / 365.25).floor
	     age.to_i
	end

		


end

