class SolutionsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :destroy, :show, :edit]
  before_filter :authorized_user, :only => [:destroy, :show, :edit]

  def create
    puts params[:solution][:problem_id]
    # TODO - how to figure out what problem this goes with
    @problem = Problem.find_by_id(params[:solution][:problem_id])
    @solution = @problem.solutions.build(params[:solution])
    if @solution.save
      flash[:success] = "Solution created!"
      redirect_to @solution
    else
      @title = @problem.name
      @solutions = @problem.solutions
      render @problem
    end
  end

  def destroy
    @solution.destroy
    redirect_to @problem
  end

  def show
    @solution = Solution.find(params[:id])
    @problem = @solution.problem
    # add questions and answers
    @title = @solution.name
  end

  def edit
    @solution = Solution.find(params[:id])
    # add answers
    @title = "Edit solution"
  end

  def update
    @solution = Solution.find(params[:id])
    if @solution.update_attributes(params[:solution])
      redirect_to @solution, :flash => { :success => "Solution updated." }
    else
      @title = "Edit solution"
      render :edit
    end
  end

  private

    def authorized_user
      begin
        @solution = Solution.find(params[:id])
      rescue
        # TODO - should we redirect to page not found?
        redirect_to root_path
      else
        redirect_to root_path unless current_user == (@solution.problem.user)
      end
    end

end
