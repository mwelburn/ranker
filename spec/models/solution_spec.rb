require 'spec_helper'

describe Solution do

  before(:each) do
    @user = Factory(:user)
    @problem = Factory(:problem, :user => @user)
    @attr = {
      :name => "Example Problem",
      :comment => "Example comments"
    }
  end

  it "should create a new instance given valid attributes" do
    @problem.solutions.create!(@attr)
  end

  describe "problem associations" do

    before(:each) do
      @solution = @problem.solutions.create(@attr)
    end

    it "should have a problem attribute" do
      @solution.should respond_to(:problem)
    end

    it "should have the right associated user" do
      @solution.problem_id.should == @problem.id
      @solution.problem.should == @problem
    end
  end

  describe "validations" do

    it "should require a problem id" do
      Solution.new(@attr).should_not be_valid
    end

    it "should require nonblank name" do
      @problem.solutions.build(@attr.merge(:name => "")).should_not be_valid
    end

    it "should reject long name" do
      @problem.solutions.build(@attr.merge(:name => "a" * 76)).should_not be_valid
    end

    it "should allow blank comment" do
      @problem.solutions.build(@attr.merge(:comment => "")).should be_valid
    end
  end

  describe "ranking" do

    before(:each) do
      @solution = @problem.solutions.create(@attr)
    end

    it "should be '0' without any questions" do
      @solution.ranking.should == 0
    end

    it "should update the ranking when questions are created" do
      @question1 = Factory(:question, :problem => @problem)
      @solution.ranking.should == 'INC'
    end

    describe "existing questions with answers" do

      before(:each) do
        @question1 = Factory(:question, :problem => @problem)
        @question2 = Factory(:question, :problem => @problem, :text => "New Text", :position => 1)
        @answer1 = Factory(:answer, :question => @question1, :solution => @solution, :rating => 1, :created_at => 1.day.ago)
        @answer2 = Factory(:answer, :question => @question2, :solution => @solution, :rating => 4, :created_at => 1.hour.ago)
      end

      it "should update the ranking when questions are updated" do
        pending
      end

      it "should update the ranking when questions are deleted" do
        pending
      end

      it "should update the ranking when answers are created" do
        pending
      end

      it "should update the ranking when answers are updated" do
        pending
      end

      it "should update the ranking when answers are deleted" do
        pending
      end

      it "should display 'INC' if not all questions have answers" do
        pending
      end

      it "should display 'INC' if not all answers have ratings" do
        pending
      end
    end
  end

  describe "answer associations" do

    before(:each) do
      @question1 = Factory(:question, :problem => @problem)
      @question2 = Factory(:question, :problem => @problem, :text => "New Text", :position => 1)
      @solution = @problem.solutions.create(@attr)
      @answer1 = Factory(:answer, :question => @question1, :solution => @solution, :rating => 1, :created_at => 1.day.ago)
      @answer2 = Factory(:answer, :question => @question2, :solution => @solution, :rating => 4, :created_at => 1.hour.ago)
    end

    it "should have a answers attribute" do
      @solution.should respond_to(:answers)
    end

    it "should have answers in the right order" do
      @solution.answers.should == [@answer2, @answer1]
    end

    it "should destroy associated answers" do
      @solution.destroy
      [@answer1, @answer2].each do |answer|
        lambda do
          Answer.find(answer)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end
