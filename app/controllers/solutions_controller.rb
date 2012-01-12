class SolutionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_problem, :only => [:new, :create]
  before_filter :load_solution, :except => [:new, :create]

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
    name = @solution.name
    if @solution.destroy
      redirect_to problem_path(@problem), :flash => { :success => "#{name} deleted" }
    else
      redirect_to @solution, :flash => { :failure => "Error deleting solution"}
    end
  end

  def show
    @title = @solution.name

    @questions = @solution.problem.questions

    unless @questions.nil?
      @questions.each do |question|
        unless @solution.answers.find_by_question_id(question.id)
          @solution.answers.create!(:question_id => question.id)
        end
      end
    end

    # sort doesn't do anything for the form since the form is unsorted
    @answers = @solution.answers.sort_by {|answer| answer.question.position}
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

  def answers
    success = @solution.update_attributes(params[:solution])
    if success
      redirect_to @problem, :flash => { :success => "Answers updated." }
    else
      @title = @solution.name
      @questions = @solution.problem.questions
      #TODO - don't think this is right
      @answers = params[:solution]
      render :show
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
          @solution = Solution.find(params[:id])
          @problem = @solution.problem
          redirect_to error_path, :flash => { :failure => "Solution does not exist" } unless @problem.user_id == current_user.id
        else
          @solution = @problem.solutions.find(params[:id])
        end
      rescue
        redirect_to error_path, :flash => { :failure => "Solution does not exist" }
      end
    end

end
