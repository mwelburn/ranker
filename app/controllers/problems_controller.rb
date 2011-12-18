class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :except => [:index, :new, :create]

  def index
    @problems = current_user.problems.paginate(:page => params[:page])
    @title = "All problems"
  end

  def new
    @problem = current_user.problems.new
    @title = "New problem"
  end

  def create
    @problem = current_user.problems.build(params[:problem])
    if @problem.save
      flash[:success] = "Problem created!"
      redirect_to @problem
    else
      render :new
    end
  end

  def destroy
    @problem = current_user.problems.find_by_id(params[:id])
    if @problem.destroy
      redirect_to problems_path, :flash => { :success => "Problem deleted" }
    else
      redirect_to @problem, :flash => { :failure => "Error deleting problem"}
    end
  end

  def show
    @problem = Problem.find_by_id(params[:id])
    @title = @problem.name
  end

  def edit
    @problem = Problem.find_by_id(params[:id])
    @title = "Edit problem"
  end

  def update
    if @problem.update_attributes(params[:problem])
      redirect_to @problem, :flash => { :success => "Problem updated." }
    else
      @title = "Edit problem"
      #this flash message never gets displayed
      render :edit#, :flash => { :failure => "Error updating problem" }
    end
  end

  private

    def authorized_user
      begin
        @problem = current_user.problems.find(params[:id])
      rescue
        flash[:failure] = "Problem does not exist"
        redirect_to "pages#error"
      end
    end

end
