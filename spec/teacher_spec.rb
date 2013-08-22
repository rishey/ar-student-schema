require 'rspec'
require 'date'
require_relative '../app/models/teacher'


describe Teacher, "#name and #age" do

  before(:all) do
    raise RuntimeError, "be sure to run 'rake db:migrate' before running these specs" unless ActiveRecord::Base.connection.table_exists?(:teachers).should be_true
    Teacher.delete_all

    @teacher = Teacher.new
    @teacher.assign_attributes(
      :first_name => "Happy",
      :last_name => "Gilmore",
      :gender => 'male',
      :birthday => Date.new(1970,9,1)
    )
  end

  it "should have name and age methods" do
    [:name, :age].each { |mthd| @teacher.should respond_to mthd }
  end

  it "should concatenate first and last name" do
    @teacher.name.should == "Happy Gilmore"
  end

  it "should be the right age" do
    now = Date.today
    age = now.year - @teacher.birthday.year - ((now.month > @teacher.birthday.month || (now.month == @teacher.birthday.month && now.day >= @teacher.birthday.day)) ? 0 : 1)
    @teacher.age.should == age
  end

end

describe Teacher, "validations" do

  before(:all) do
    raise RuntimeError, "be sure to run 'rake db:migrate' before running these specs" unless ActiveRecord::Base.connection.table_exists?(:teachers).should be_true
    Teacher.delete_all
  end

  before(:each) do
    @teacher = Teacher.new
    @teacher.assign_attributes(
      :first_name => "Kreay",
      :last_name => "Shawn",
      :birthday => Date.new(1989,9,24),
      :gender => 'female',
      :email => 'kreayshawn@oaklandhiphop.net',
      :phone => '(510) 555-1212 x4567'
    )
  end

  it "should accept valid info" do
    @teacher.should be_valid
  end

  it "shouldn't accept invalid emails" do
    ["XYZ!bitnet", "@.", "a@b.c"].each do |address|
      @teacher.assign_attributes(:email => address)
      @teacher.should_not be_valid
    end
  end

  it "should accept valid emails" do
    ["joe@example.com", "info@bbc.co.uk", "bugs@devbootcamp.com"].each do |address|
      @teacher.assign_attributes(:email => address)
      @teacher.should be_valid
    end
  end

  it "shouldn't accept toddlers" do
    @teacher.assign_attributes(:birthday => Date.today - 3.years)
    @teacher.should_not be_valid
  end

  it "shouldn't allow two teachers with the same email" do
    another_teacher = Teacher.create!(
      :birthday => @teacher.birthday,
      :email => @teacher.email,
      :phone => @teacher.phone
    )
    @teacher.should_not be_valid
  end

end

describe Teacher, "advanced validations" do

  before(:all) do
    raise RuntimeError, "be sure to run 'rake db:migrate' before running these specs" unless ActiveRecord::Base.connection.table_exists?(:teachers).should be_true
    Teacher.delete_all
  end

  before(:each) do
    @teacher = Teacher.new
    @teacher.assign_attributes(
      :first_name => "Kreay",
      :last_name => "Shawn",
      :birthday => Date.new(1989,9,24),
      :gender => 'female',
      :email => 'kreayshawn@oaklandhiphop.net',
      :phone => '(510) 555-1212 x4567'
    )
  end

  it "should accept valid info" do
    @teacher.should be_valid
  end

  it "shouldn't accept invalid phone numbers" do
    @teacher.assign_attributes(:phone => '347-8901')
    @teacher.should_not be_valid
  end

end
