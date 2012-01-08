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
    if @solution.destroy
      redirect_to problem_solutions_path(@problem), :flash => { :success => "Solution deleted" }
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
    errors = @solution.update_answers(params[:answer])
    if errors.empty?
      redirect_to @problem, :flash => { :success => "Answers updated." }
    else
      @title = @solution.name
      @questions = @solution.problem.questions
      #TODO - don't think this is right
      @answers = params[:answer]
      render :show
    end
    #TODO - need to handle failures due to validation -- wrap this in a transaction?? needs to give user feedback via the error flash message

    #TODO - need to verify the user actually has access to the answers...they should if solution is validated
    #TODO - do a check incase new answers are added, do they respect validation (can't have 2 answers to a problem, etc)
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
