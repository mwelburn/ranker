require 'spec_helper'

describe Question do

  before(:each) do
    @user = Factory(:user)
    @problem = Factory(:problem, :user => @user)
    @attr = {
      :text => "Example Question",
      :position => 0,
      :weight => 1
    }
  end

  it "should create a new instance given valid attributes" do
    @problem.questions.create!(@attr)
  end

  describe "question associations" do

    before(:each) do
      @question = @problem.questions.create(@attr)
    end

    it "should have a problem attribute" do
      @question.should respond_to(:problem)
    end

    it "should have the right associated problem" do
      @question.problem_id.should == @problem.id
      @question.problem.should == @problem
    end
  end

  describe "validations" do

    it "should require a problem id" do
      Question.new(@attr).should_not be_valid
    end

    it "should require nonblank text" do
      @problem.questions.build(@attr.merge(:text => "")).should_not be_valid
    end

    it "should reject non number positions" do
      invalid_positions = %w[a % !]
      invalid_positions.each do |position|
        @problem.questions.build(@attr.merge(:position => position)).should_not be_valid
      end
    end

    it "should reject invalid number positions" do
      invalid_positions = [-1, 3.4]
      invalid_positions.each do |position|
        @problem.questions.build(@attr.merge(:position => position)).should_not be_valid
      end
    end

    it "should allow valid integer positions" do
      valid_positions = %w[1 3 5]
      valid_positions.each do |position|
        @problem.questions.build(@attr.merge(:position => position)).should be_valid
      end
    end

    it "should reject non number weights" do
      invalid_weights = %w[a % !]
      invalid_weights.each do |weight|
        @problem.questions.build(@attr.merge(:weight => weight)).should_not be_valid
      end
    end

    it "should reject invalid number weights" do
      invalid_weights = [-1, 6, 3.4]
      invalid_weights.each do |weight|
        @problem.questions.build(@attr.merge(:weight => weight)).should_not be_valid
      end
    end

    it "should allow valid integer weight" do
      valid_weights = [1, 3, 5]
      valid_weights.each do |weight|
        @problem.questions.build(@attr.merge(:weight => weight)).should be_valid
      end
    end
  end

  describe "answer associations" do

    before(:each) do
      @solution = Factory(:solution, :problem => @problem)
      @question = @problem.questions.create(@attr)
      @answer1 = Factory(:answer, :question => @question, :solution => @solution, :rating => 1, :created_at => 1.day.ago)
      @answer2 = Factory(:answer, :question => @question, :solution => @solution, :rating => 4, :created_at => 1.hour.ago)
    end

    it "should have a answers attribute" do
      @question.should respond_to(:answers)
    end

    it "should have answers in the right order" do
      @question.answers.should == [@answer2, @answer1]
    end

    it "should destroy associated answers" do
      @question.destroy
      [@answer1, @answer2].each do |answer|
        lambda do
          Answer.find(answer)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
