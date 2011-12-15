class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :except => :create

  def create
    @problem = current_user.problems.build(params[:problem])
    if @problem.save
      flash[:success] = "Problem created!"
      redirect_to @problem
    else
      redirect_to root_path
      #TODO - this should render the create path so you can fix errors
      #render root_path
    end
  end

  def destroy
    @problem.destroy
    redirect_to root_path
  end

  def show
    @problem = Problem.find(params[:id])
    # TODO - once we remove pagination, we need to figure out why "new" is adding an empty value to the array
    @solutions = @problem.solutions.paginate(:page => params[:page])
    @solution = @problem.solutions.new
    # add questions and solutions
    @title = @problem.name
  end

  def edit
    @problem = Problem.find(params[:id])
    # add questions
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
    @problem = Problem.find(params[:id])
    # TODO - once we remove pagination, we need to figure out why "new" is adding an empty value to the array
    @questions = @problem.questions
    # TODO - new or build? want to default weight to 1
    @question = @problem.questions.build({:weight => 1})
    @title = "Edit questions"
  end

  private

    def authorized_user
      begin
        @problem = Problem.find(params[:id])
      rescue
        # TODO - should we redirect to page not found?
        redirect_to root_path
      else
        redirect_to root_path unless current_user == (@problem.user)
      end
    end

end
