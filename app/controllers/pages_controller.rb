class PagesController < ApplicationController
  
  def home
    @title = "Home"
    if user_signed_in?
      @problems = current_user.problems.paginate(:page => params[:page])
    end
  end
  
  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

  def error
    @title = "Page Not Found"
  end
end
