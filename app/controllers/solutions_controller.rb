class SolutionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_problem, :only => [:index, :new, :create]
  before_filter :load_solution, :except => [:index, :new, :create]

  def index
    @solutions = @problem.solutions
    @title = "All solutions"
  end

  def new
    @solution = @problem.solutions.new
    @title = "New solution"
  end

  def create
    @solution = @problem.solutions.build(params[:solution])
    if @solution.save
      redirect_to @solution, :flash => { :success => "Solution created!" }
    else
      render :new
    end
  end

  def destroy
    if @solution.destroy
      redirect_to problem_solutions_path(@problem), :flash => { :success => "Solution deleted" }
    else
      redirect_to @solution, :flash => { :failure => "Error deleting solution"}
    end
  end

  def show
    @title = @solution.name
  end

  def edit
    @title = "Edit solution"
  end

  def update
    if @solution.update_attributes(params[:solution])
      redirect_to @solution, :flash => { :success => "Solution updated." }
    else
      @title = "Edit solution"
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

    def load_solution
      begin
        if @problem.nil?
          if @solution = Solution.find(params[:id])
            @problem = @solution.problem
            redirect_to error_path, :flash => { :failure => "Solution does not exist" } unless @problem.user_id == current_user.id
          end
        else
          @solution = @problem.solutions.find(params[:id])
        end
      rescue
        redirect_to error_path, :flash => { :failure => "Solution does not exist" }
      end
    end

end
