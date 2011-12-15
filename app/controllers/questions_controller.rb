class QuestionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :except => :create

  def create
    # TODO - how to figure out what problem this goes with
    @problem = Problem.find_by_id(params[:question].problem_id)
    @question = @problem.questions.build(params[:question])
    if @question.save
      flash[:success] = "Question created!"
      redirect_to problem_questions_path(@problem)
    else
      render @problem
    end
  end

  def destroy
    @question.destroy
    redirect_to problem_questions_path(@problem)
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

    def authorized_user
      begin
        @question = Question.find(params[:id])
      rescue
        # TODO - should we redirect to page not found?
        redirect_to root_path
      else
        redirect_to root_path unless current_user == (@question.problem.user)
      end
    end

end
