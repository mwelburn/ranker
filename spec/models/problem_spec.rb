require 'spec_helper'

describe Problem do

  before(:each) do
    @user = Factory(:user)
    @attr = {
      :name => "Example Problem",
      :comment => "Example comments",
      :public => false
    }
  end

  it "should create a new instance given valid attributes" do
    @user.problems.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @problem = @user.problems.create(@attr)
    end

    it "should have a user attribute" do
      @problem.should respond_to(:user)
    end

    it "should have the right associated user" do
      @problem.user_id.should == @user.id
      @problem.user.should == @user
    end
  end

  describe "validations" do

    it "should require a user id" do
      Problem.new(@attr).should_not be_valid
    end

    it "should require nonblank name" do
      @user.problems.build(@attr.merge(:name => "")).should_not be_valid
    end

    it "should reject long name" do
      @user.problems.build(@attr.merge(:name => "a" * 76)).should_not be_valid
    end

    it "should allow blank comment" do
      @user.problems.build(@attr.merge(:comment => "")).should be_valid
    end

    it "should default public to false if blank" do
      @problem = @user.problems.build(@attr.merge(:public => ""))
      @problem.public == false
    end
  end

  describe "solution associations" do

    before(:each) do
      @problem = @user.problems.create(@attr)
      @solution1 = Factory(:solution, :problem => @problem, :name => "Solution 1")
      @solution2 = Factory(:solution, :problem => @problem, :name => "Solution 2")
    end

    it "should have a solutions attribute" do
      @problem.should respond_to(:solutions)
    end

    it "should have solutions in the right order" do
      pending "Need to test that they go from low to high, and INC is after 0"
    end

    it "should destroy associated solutions" do
      @problem.destroy
      [@solution1, @solution2].each do |solution|
        lambda do
          Solution.find(solution)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "question associations" do

    before(:each) do
      @problem = @user.problems.create(@attr)
      @question1 = Factory(:question, :problem => @problem, :text => "Question 1", :position => 2)
      @question2 = Factory(:question, :problem => @problem, :text => "Question 2", :position => 1)
    end

    it "should have a questions attribute" do
      @problem.should respond_to(:questions)
    end

    it "should have questions in the right order" do
      @problem.questions.should == [@question2, @question1]
    end

    it "should destroy associated questions" do
      @problem.destroy
      [@question1, @question2].each do |question|
        lambda do
          Question.find(question)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end
