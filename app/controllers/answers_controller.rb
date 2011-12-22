class AnswersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_answer, :only => [:update]
  before_filter :load_question, :only => [:create]
  before_filter :load_solution, :only => [:create]

  def create
    @answer = @solution.build(params[:answer])
    if @answer.save
      redirect_to @solution, :flash => { :success => "Answer created!" }
    else
      @title = @solution.name
      render @solution
    end
  end

  def update
    if @answer.update_attributes(params[:answer])
      redirect_to @solution, :flash => { :success => "Answer updated." }
    else
      @title = @solution.name
      render @solution
    end
  end

  private

    def load_question
      begin
        @question = Question.find(params[:question_id])
        redirect_to error_path, :flash => { :failure => "Answer does not exist" } unless @question.problem.user.id == current_user.id
      rescue
        redirect_to error_path, :flash => { :failure => "Answer does not exist" }
      end
    end

    def load_solution
      begin
        @solution = Solution.find(params[:solution_id])
        redirect_to error_path, :flash => { :failure => "Answer does not exist" } unless @solution.problem.user.id == current_user.id
      rescue
        redirect_to error_path, :flash => { :failure => "Answer does not exist" }
      end
    end

    def load_answer
      begin
        @answer = Answer.find(params[:id])
        @question = @answer.question
        @problem = @question.problem
        @solution = @answer.solution
        redirect_to error_path, :flash => { :failure => "Answer does not exist" } unless @problem.user.id == current_user.id
      rescue
        redirect_to error_path, :flash => { :failure => "Answer does not exist" }
      end
    end

end