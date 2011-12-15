require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  # Most of the basic functionality is tested within Devise. We will just test extensions
  # of that functionality here

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  describe "problem associations" do

    before(:each) do
      @user = User.create(@attr)
      @problem1 = Factory(:problem, :user => @user, :name => "Problem 1", :created_at => 1.day.ago)
      @problem2 = Factory(:problem, :user => @user, :name => "Problem 2", :created_at => 1.hour.ago)
    end

    it "should have a problems attribute" do
      @user.should respond_to(:problems)
    end

    it "should have problems in the right order" do
      @user.problems.should == [@problem2, @problem1]
    end

    it "should destroy associated problems" do
      @user.destroy
      [@problem1, @problem2].each do |problem|
        lambda do
          Problem.find(problem)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
