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

  #TODO - should all of this be isolated within the observer spec...within here, explicitly test methods
  describe "ranking" do

    before(:each) do
      @problem = @user.problems.create(@attr)
    end

    it "should be '0' without any questions" do
      @problem.question_total.should == 0
    end

    it "should update the ranking when questions are created" do
      weight = 3

      lambda do
        Factory(:question, :problem => @problem, :weight => weight)
      end.should change(@problem, :question_total).by(weight)
    end

    describe "existing questions with answers" do

      before(:each) do
        @solution = Factory(:solution, :problem => @problem)
        @question1 = Factory(:question, :problem => @problem)
        @question2 = Factory(:question, :problem => @problem, :text => Factory.next(:text), :position => 1)
        @answer1 = Factory(:answer, :question => @question1, :solution => @solution, :rating => 1, :created_at => 1.day.ago)
        @answer2 = Factory(:answer, :question => @question2, :solution => @solution, :rating => 4, :created_at => 1.hour.ago)
      end

      it "should update the ranking when questions are created" do
        weight = 4

        lambda do
          Factory(:question, :problem => @problem, :text => Factory.next(:text), :weight => weight)
        end.should change(@problem, :question_total).by(weight)
      end

      it "should update the ranking when questions are deleted" do
        weight = @question2.weight

        lambda do
          @question2.destroy
        end.should change(@problem, :question_total).by(-weight)
      end

      pending

    end
  end
end
