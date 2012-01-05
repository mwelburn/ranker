require 'spec_helper'

describe AnswerObserver do

  before(:each) do
    @user = Factory(:user)
    @problem = Factory(:problem, :user => @user)

    5.times do
      Factory(:question, :problem => @problem, :text => Factory.next(:text))
    end

    @solution = Factory(:solution, :problem => @problem, :name => Factory.next(:name))

    @problem.questions.each do |question|
      Factory(:answer, :solution => @solution, :question_id => question.id)
    end
  end

  describe "after_save" do

    before(:each) do
      @question = Factory(:question, :problem => @problem, :text => Factory.next(:text))
    end

    it "should re-validate solution" do
      Factory(:answer, :solution => @solution, :question_id => @question.id)
      @solution.completed.should == true
    end

    it "should update the answer total" do
      weight = @question.weight
      rating = 3
      lambda do
        Factory(:answer, :solution => @solution, :question_id => @question.id, :rating => rating)
      end.should change(@solution, :answer_total).by(weight * rating)
    end
  end
end
