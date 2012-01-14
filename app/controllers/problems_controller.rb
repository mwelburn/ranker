class ProblemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_problem, :except => [:index, :new, :create, :copy]

  def new
    @problem = current_user.problems.new
    @title = "New problem"
  end

  def create
    @problem = current_user.problems.build(params[:problem])
    if @problem.save
      if @problem.has_template_id?
        #TODO - handle failure of copy template questions better. Redirect to problem show and build up the questions and let them save?
        @problem.copy_template_questions
        redirect_to @problem, :flash => { :success => "Template copied!" }
      else
        redirect_to @problem, :flash => { :success => "Problem created!" }
      end
    else
      render :new
    end
  end

  def copy
    template = Problem.find_by_id_and_is_template(params[:id], true)
    if template.blank?
      redirect_to "pages/home", :flash => { :failure => "Template does not exist" }
    end
    @problem = current_user.problems.build(template.attributes.merge(:is_template => false, :template_id => template.id))
    @title = "Copy Template"
    render :new
  end

  def destroy
    name = @problem.name
    if @problem.destroy
      redirect_to "pages/home", :flash => { :success => "#{name} deleted" }
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
    success = @problem.update_attributes(params[:problem])
    if success
      redirect_to @problem, :flash => { :success => "Questions updated." }
    else
      @title = @problem.name
      #TODO - don't think this is right
      @questions = params[:problem]
      @solutions = @problem.solutions
      render 'problems/show'
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
