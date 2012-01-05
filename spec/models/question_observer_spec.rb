require 'spec_helper'

describe QuestionObserver do

  before(:each) do
    @user = Factory(:user)
    @problem = Factory(:problem, :user => @user)

    5.times do
      Factory(:question, :problem => @problem, :text => Factory.next(:text))
    end

    5.times do
      solution = Factory(:solution, :problem => @problem, :name => Factory.next(:name))

      @problem.questions.each do |question|
        Factory(:answer, :solution => solution, :question_id => question.id)
      end
    end
  end

  describe "after_create" do

    it "should invalidate solutions" do
      Factory(:question, :problem => @problem, :text => Factory.next(:text))
      @problem.solutions.each do |solution|
        solution.completed.should == false
      end
    end
  end

  describe "after_save" do

    it "should update the question total after creating a new question" do
      weight = 3
      lambda do
        Factory(:question, :problem => @problem, :text => Factory.next(:text), :weight => weight)
      end.should change(@problem, :question_total).by(weight)
    end

    it "should update the question total after updating an existing question" do
      question = @problem.questions.first
      original_weight = question.weight
      new_weight = 3

      lambda do
        question.update_attributes(:weight => new_weight)
      end.should change(question.problem, :question_total).by((new_weight - original_weight))
    end

    it "should not update the question total if weight doesn't change" do
      question = @problem.questions.first
      original_weight = question.weight

      lambda do
        question.update_attributes(:weight => original_weight)
      end.should_not change(question.problem, :question_total)
    end
  end

  describe "after_destroy" do

    it "should re-validate all solutions" do
      pending "test a solution that only had that question incomplete"
    end

    it "should update the question total" do
      question = @problem.questions.first
      weight = question.weight

      lambda do
        question.destroy
      end.should change(question.problem, :question_total).by(-weight)
    end

    it "should update the answer totals of all solutions" do
      pending
    end
  end
end
