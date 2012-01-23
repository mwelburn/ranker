class CategoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_category, :only => [:update, :delete]

  def create
    @category = @solution.build(params[:category])
    if @category.save
      redirect_to @problem, :flash => { :success => "Category created!" }
    else
      @title = @category.name
      render @category
    end
  end

  def update
    if @category.update_attributes(params[:category])
      redirect_to @problem, :flash => { :success => "Category updated." }
    else
      @title = @category.name
      render @category
    end
  end

  private

    def load_category
      begin
        @category = Category.find(params[:id])
        @problem = @category.problem
        redirect_to error_path, :flash => { :failure => "Category does not exist" } unless @problem.user.id == current_user.id
      rescue
        redirect_to error_path, :flash => { :failure => "Category does not exist" }
      end
    end

end