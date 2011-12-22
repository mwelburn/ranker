require 'spec_helper'

describe SolutionsController do
  render_views

  describe "access control" do

    before(:each) do
      @user = Factory(:user)
      @problem = Factory(:problem, :user => @user)
      @solution = Factory(:solution, :problem => @problem)
      @question = Factory(:question, :problem => @problem)
      @answer = Factory(:answer, :solution => @solution, :question => @question)
      @attr = {
          @answer.id => {:question_id => @question.id,
                         :rating => 2,
                        :comment => "Updated Answer Comment"
          }
      }
    end

    it "should deny access to 'index'" do
      get :index, :problem_id => @problem.id
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'new'" do
      get :new, :problem_id => @problem.id
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'create'" do
      post :create, :problem_id => @problem.id
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => @solution
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'show'" do
      get :show, :id => @solution
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'edit'" do
      get :edit, :id => @solution
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'update'" do
      put :update, :id => @solution, :solution => { :name => "Updated Name" }
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'answers'" do
      put :answers, :id => @solution, :answers => @attr
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'index'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @problem = Factory(:problem, :user => @user)

      30.times do
        Factory(:solution, :problem => @problem,
                           :name => Factory.next(:name))
      end
      
      @other_problem = Factory(:problem, :user => @user, :name => "Other problem")
      @other_solution = Factory(:solution, :problem => @other_problem, :name => "Other problem's solution")
    end

    it "should be successful" do
      get :index, :problem_id => @problem.id
      response.should be_success
    end

    it "should have the right title" do
      get :index, :problem_id => @problem.id
      response.should have_selector('title', :content => "All solutions")
    end

    it "should have an element for each problem's solution" do
      get :index, :problem_id => @problem.id
      @problem.solutions.each do |solution|
        response.should have_selector('li', :content => solution.name)
        #TODO - add comment
        #response.should have_selector('span.comment', :content => solution.comment)
      end
    end

    #this test requires the solution's not have the same name
    it "should not contain other problem's solution" do
      get :index, :problem_id => @problem.id
      @other_problem.solutions.each do |solution|
        response.should_not have_selector('li', :content => solution.name)
      end
    end

    #TODO - find a pagination gem that works in 3.1
    it "should paginate solutions" do
      pending
#      get :index, :problem_id => @problem.id
#      response.should have_selector('div.pagination')
#      response.should have_selector('span.disabled', :content => "Previous")
#      response.should have_selector('a', :href => "/solutions?page=2",
#                                         :content => "2")
#      response.should have_selector('a', :href => "/solutions?page=2",
#                                         :content => "Next")
    end

    it "should have delete links" do
      get :index, :problem_id => @problem.id
      @problem.solutions.each do |solution|
        response.should have_selector('a', :href => solution_path(solution),
                                           :content => "delete")
      end
    end

    it "should have a link to create a new solution" do
      get :index, :problem_id => @problem.id
      response.should have_selector('a', :href => new_problem_solution_path(@solution),
                                         :content => "New Solution?")
    end
  end

  describe "GET 'new'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @problem = Factory(:problem, :user => @user)
    end

    it "should be successful" do
      get :new, :problem_id => @problem.id
      response.should be_success
    end

    it "should have the right title" do
      get :new, :problem_id => @problem.id
      response.should have_selector('title', :content => "New solution")
    end

  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @problem = Factory(:problem, :user => @user)
    end

    describe "success" do

      before(:each) do
        @attr = {
          :name => "Test Solution Name",
          :comment => "Test Solution Comment"
        }
      end

      it "should create a solution" do
        lambda do
          post :create, :problem_id => @problem.id, :solution => @attr
        end.should change(Solution, :count).by(1)
      end

      it "should not require a comment" do
        lambda do
          post :create, :problem_id => @problem.id, :solution => @attr.merge(:comment => "")
        end.should change(Solution, :count).by(1)
      end

      it "should redirect to the solution page" do
        post :create, :problem_id => @problem.id, :solution => @attr
        #this only works as long as there are no other solutions for this problem yet
        @solution = @problem.solutions.last
        response.should redirect_to(solution_path(@solution))
      end

      it "should have a flash message" do
        post :create, :problem_id => @problem.id, :solution => @attr
        flash[:success].should =~ /solution created/i
      end
    end

    describe "failure" do

      before(:each) do
        @attr = {
          :name => ""
        }
      end

      it "should not create a solution" do
        lambda do
          post :create, :problem_id => @problem.id, :solution => @attr
        end.should_not change(Solution, :count)
      end

      it "should render the new solution page" do
        post :create, :problem_id => @problem.id, :solution => @attr
        response.should render_template("solutions/new")
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        @problem = Factory(:problem, :user => @user)
        @solution = Factory(:solution, :problem => @problem)
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        delete :destroy, :id => @solution
        response.should redirect_to(error_path)
      end

      it "should not destroy the solution" do
        lambda do
          delete :destroy, :id => @solution
        end.should_not change(Solution, :count)
      end

      it "should have a flash message" do
        delete :destroy, :id => @solution
        flash[:failure].should =~ /solution does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @problem = Factory(:problem, :user => @user)
        @solution = Factory(:solution, :problem => @problem)
      end

      describe "success" do

        it "should destroy the solution" do
          lambda do
            delete :destroy, :id => @solution
          end.should change(Solution, :count).by(-1)
        end
      end

      describe "failure" do

        it "should have a flash message" do
          pending
          #TODO - how do I make it fail with a legit solution ID
          #delete :destroy, :id => @solution
          #flash[:failure].should =~ /error deleting solution/i
        end

        it "should render the problem page" do
          pending
          #TODO - how do I make it fail with a legit solution ID
          #delete :destroy, :id => @solution
          #response.should redirect_to(question_path(@solution))
        end

        it "should render an error page when trying to access an invalid solution" do
          get :edit, :id => 1000
          response.should redirect_to(error_path)
        end
      end
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      @problem = Factory(:problem, :user => @user)
      @solution = Factory(:solution, :problem => @problem)
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        get :show, :id => @solution
        response.should redirect_to(error_path)
      end

      it "should have a flash message" do
        get :show, :id => @solution
        flash[:failure].should =~ /solution does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should be successful" do
          get :show, :id => @solution
          response.should be_success
        end

        it "should find the right solution" do
          get :show, :id => @solution
          assigns(:solution).should == @solution
        end

        it "should have the right title" do
          get :show, :id => @solution
          response.should have_selector("title", :content => @solution.name)
        end

        it "should have a link to the solutions page" do
          get :show, :id => @solution
          response.should have_selector("a", :content => "Solutions")
        end

        it "should have a link to the edit solution page" do
          get :show, :id => @solution
          response.should have_selector("a", :content => "Edit Solution")
        end

        it "should have the solution's text" do
          get :show, :id => @solution
          response.should have_selector("h1", :content => @solution.name)
        end

        it "should include the solution's comment" do
          get :show, :id => @solution
          response.should have_selector("span", :content => @solution.comment)
        end

        it "should include the solution's ranking" do
          get :show, :id => @solution
          response.should have_selector("span", :content => @solution.ranking)
        end
      end

      describe "failure" do

        it "should render an error page when trying to access an invalid solution" do
          get :show, :id => 1000
          response.should redirect_to(error_path)
        end
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      @problem = Factory(:problem, :user => @user)
      @solution = Factory(:solution, :problem => @problem)
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        get :edit, :id => @solution
        response.should redirect_to(error_path)
      end

      it "should have a flash message" do
        get :edit, :id => @solution
        flash[:failure].should =~ /solution does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should be successful" do
          get :edit, :id => @solution
          response.should be_success
        end

        it "should find the right solution" do
          get :edit, :id => @solution
          assigns(:solution).should == @solution
        end

        it "should have the right title" do
          get :edit, :id => @solution
          response.should have_selector("title", :content => "Edit solution")
        end

        pending "it should show the existing attributes in the fields"
      end

      describe "failure" do

        it "should render an error page when trying to access an invalid solution" do
          get :edit, :id => 1000
          response.should redirect_to(error_path)
        end
      end
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      @problem = Factory(:problem, :user => @user)
      @solution = Factory(:solution, :problem => @problem)
      @attr = {
          :name => "Updated Solution Name",
          :comment => "Updated Solution Comment"
      }
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        put :update, :id => @solution, :solution => @attr
        response.should redirect_to(error_path)
      end

      it "should not edit the solution" do
        put :update, :id => @solution, :solution => @attr
        @solution.reload
        @solution.name.should_not == @attr[:name]
        @solution.comment.should_not == @attr[:comment]
      end

      it "should have a flash message" do
        put :update, :id => @solution, :solution => @attr
        flash[:failure].should =~ /solution does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should change the solution's attributes" do
          put :update, :id => @solution, :solution => @attr
          @solution.reload
          @solution.name.should == @attr[:name]
          @solution.comment.should == @attr[:comment]
        end

        it "should redirect to the solution page" do
          put :update, :id => @solution, :solution => @attr
          response.should redirect_to(solution_path)
        end

        it "should have a flash message" do
          put :update, :id => @solution, :solution => @attr
          flash[:success].should =~ /solution updated/i
        end
      end

      describe "failure" do

        before(:each) do
          @bad_attr = {
              :name => "",
              :comment => "" #comment can be blank, but name cannot
          }
        end

        it "should have a flash message" do
          pending
#          put :update, :id => @solution, :solution => @bad_attr
#          flash[:failure].should =~ /error updating solution/i
        end

        it "should render the solution page" do
          put :update, :id => @solution, :solution => @bad_attr
          response.should render_template("solutions/edit")
        end

        it "should not edit the question" do
          put :update, :id => @solution, :solution => @bad_attr
          @solution.reload
          @solution.name.should_not == @bad_attr[:name]
          @solution.comment.should_not == @bad_attr[:comment]
        end

        it "should render an error page when trying to access an invalid solution" do
          put :update, :id => 1000, :solution => @attr
          response.should redirect_to(error_path)
        end
      end
    end
  end

  describe "PUT 'answers'" do

    before(:each) do
      @user = Factory(:user)
      @problem = Factory(:problem, :user => @user)
      @question = Factory(:question, :problem => @problem)
      @solution = Factory(:solution, :problem => @problem)
      @answer = Factory(:answer, :solution => @solution, :question => @question)
      @attr = {
          @answer.id => {:question_id => @question.id,
                         :rating => 2,
                        :comment => "Updated Answer Comment"
          }
      }
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        put :answers, :id => @solution, :answers => @attr
        response.should redirect_to(error_path)
      end

      it "should not edit the answers" do
        pending
#        put :answers, :id => @solution, :answers => @attr
#        @solution.reload
#        @solution.name.should_not == @attr[:name]
#        @solution.comment.should_not == @attr[:comment]
      end

      it "should have a flash message" do
        put :answers, :id => @solution, :answers => @attr
        flash[:failure].should =~ /solution does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do
        pending
        #TODO- make sure to test updating a single answer, as well as updating many
      end

      describe "failure" do
        pending
        #TODO- test some failures in a batch of successes
      end
    end
  end
end
