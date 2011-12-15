require 'spec_helper'

describe Answer do

  before(:each) do
    @user = Factory(:user)
    @problem = Factory(:problem, :user => @user)
    @question = Factory(:question, :problem => @problem)
    @solution = Factory(:solution, :problem => @problem)
    @attr = {
      :question_id => @question,
      :rating => 1,
      :comment => "Answer Comment"
    }
  end

  it "should create a new instance given valid attributes" do
    @solution.answers.create!(@attr)
  end

  describe "answer associations" do

    before(:each) do
      @answer = @solution.answers.create(@attr)
    end

    it "should have a question attribute" do
      @answer.should respond_to(:question)
    end

    it "should have a solution attribute" do
      @answer.should respond_to(:solution)
    end

    it "should have the right associated question" do
      @answer.question_id.should == @question.id
      @answer.question.should == @question
    end

    it "should have the right associated solution" do
      @answer.solution_id.should == @solution.id
      @answer.solution.should == @solution
    end
  end

  describe "validations" do

    it "should require a question id" do
      Answer.new(@attr).should_not be_valid
    end

    it "should require a question id" do
      @solution.answers.create(@attr.merge(:question_id => "")).should_not be_valid
    end

    it "should reject non number ratings" do
      invalid_ratings = %w[a % !]
      invalid_ratings.each do |rating|
        @solution.answers.build(@attr.merge(:rating => rating)).should_not be_valid
      end
    end

    it "should reject invalid number ratings" do
      invalid_ratings = [-1, 6, 3.4]
      invalid_ratings.each do |rating|
        @solution.answers.build(@attr.merge(:rating => rating)).should_not be_valid
      end
    end

    it "should allow valid integer ratings" do
      valid_ratings = [1, 3, 5]
      valid_ratings.each do |rating|
        @solution.answers.build(@attr.merge(:rating => rating)).should be_valid
      end
    end
    
    pending "there can't be more than one answer per solution to a question"
  end
end
