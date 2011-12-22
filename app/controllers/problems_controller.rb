class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_problem, :except => [:index, :new, :create]

  def index
    @problems = current_user.problems
    @title = "All problems"
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
    #TODO- reverse the sort order so it is DESC
    #TODO- put INC at the end
    @solutions = @problem.solutions.sort_by {|solution| solution.ranking}
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

  private

    def load_problem
      begin
        @problem = current_user.problems.find(params[:id])
      rescue
        redirect_to error_path, :flash => { :failure => "Problem does not exist"}
      end
    end

end
