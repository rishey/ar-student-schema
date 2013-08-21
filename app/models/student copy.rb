require_relative '../../db/config'

class Student < ActiveRecord::Base
  def initialize(attributes = {})
  	attributes.symbolize_keys!
    raise_error_if_invalid_attribute!(attributes.keys)
    @attributes = {}
	    self.class.attribute_names.each do |name|
		  @attributes[name] = attributes[name]
	    end
	@old_attributes = @attributes.dup
  end

  self.attribute_names = [:id, :first_name, :last_name, :gender, :birthday, :email, :phone]
  attr_reader :attributes, :old_attributes

  def name
  end

  def self.all
	    Database::Model.execute("SELECT * FROM students").map do |row|
	      self.new(row)
	    end
  	end
end

student.all