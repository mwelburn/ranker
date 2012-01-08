class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_problem, :except => [:index, :new, :create]

  def index
    @problems = current_user.problems
    @title = "Problems"
  end

  def new
    @problem = current_user.problems.new
    @title = "New problem"
  end

  def create
    @problem = current_user.problems.build(params[:problem])
    if @problem.save
      redirect_to @problem, :flash => { :success => "Problem created!" }
    else
      render :new
    end
  end

  def destroy
    if @problem.destroy
      redirect_to problems_path, :flash => { :success => "Problem deleted" }
    else
      redirect_to @problem, :flash => { :failure => "Error deleting problem"}
    end
  end

  def show
    @title = @problem.name
    @questions = @problem.questions
    @solutions = @problem.solutions
  end

  def edit
    @title = "Edit problem"
  end

  def update
    if @problem.update_attributes(params[:problem])
      redirect_to @problem, :flash => { :success => "Problem updated." }
    else
      @title = "Edit problem"
      render :edit
    end
  end

  def questions
    errors = @problem.update_questions(params[:question])
    if errors.empty?
      redirect_to @problem, :flash => { :success => "Questions updated." }
    else
      @title = @problem.name
      #TODO - don't think this is right
      @questions = params[:question]
      @solutions = @problem.solutions
      render 'problems/show'
    end
    #TODO - need to handle failures due to validation -- wrap this in a transaction?? needs to give user feedback via the error flash message

    #TODO - need to verify the user actually has access to the questions...they should if solution is validated
    #TODO - do a check incase new questions are added, do they respect validation (can't have 2 answers to a problem, etc)
  end

  private

    def load_problem
      begin
        @problem = current_user.problems.find(params[:id])
      rescue
        redirect_to error_path, :flash => { :failure => "Problem does not exist"}
      end
    end

end
