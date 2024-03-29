class QuestionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_problem, :only => [ :create ]
  before_filter :load_question, :except => [ :create ]

  def create
    @question = @problem.questions.build(params[:question])
    if @question.save
      redirect_to problem_questions_path(@problem), :flash => { :success => "Question created!" }
    else
      render :new
    end
  end

  def destroy
    problem = @question.problem
    if @question.destroy
      redirect_to problem_questions_path(@problem), :flash => { :success => "Question deleted" }
    else
      redirect_to @question, :flash => { :failure => "Error deleting question"}
    end
  end

  def update
    if @question.update_attributes(params[:question])
      redirect_to @question, :flash => { :success => "Question updated." }
    else
      @title = "Edit question"
      render :edit
    end
  end

  private

    def load_problem
      begin
        @problem = current_user.problems.find(params[:problem_id])
      rescue
        redirect_to error_path, :flash => { :failure => "Problem does not exist" }
      end
    end

    def load_question
      begin
        if @problem.nil?
          @question = Question.find(params[:id])
          @problem = @question.problem
          redirect_to error_path, :flash => { :failure => "Question does not exist" } unless @problem.user_id == current_user.id
        else
          @question = @problem.questions.find(params[:id])
        end
      rescue
        redirect_to error_path, :flash => { :failure => "Question does not exist" }
      end
    end

end
