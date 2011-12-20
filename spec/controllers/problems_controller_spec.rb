require 'spec_helper'

describe ProblemsController do
  render_views

  describe "access control" do

    before(:each) do
      @user = Factory(:user)
      @problem = Factory(:problem, :user => @user)
    end

    it "should deny access to 'index'" do
      get :index
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'new'" do
      get :new
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => @problem
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'show'" do
      get :show, :id => @problem
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'edit'" do
      get :edit, :id => @problem
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'update'" do
      put :update, :id => @problem, :problem => { :name => "Updated Name" }
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'index'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))

      30.times do
        Factory(:problem, :user => @user,
                          :name => Factory.next(:name))
      end

      @other_user = Factory(:user, :email => Factory.next(:email))
      @other_problem = Factory(:problem, :user => @other_user, :name => "Other problem")
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
      response.should have_selector('title', :content => "All problems")
    end

    it "should have an element for each user's problem" do
      get :index
      @user.problems.each do |problem|
        response.should have_selector('li', :content => problem.name)
      end
    end

    #this test requires the problem's not have the same name
    it "should not contain other user's problems" do
      get :index
      @other_user.problems.each do |problem|
        response.should_not have_selector('li', :content => problem.name)
      end
    end

    #TODO - find a pagination gem that works in 3.1
    it "should paginate problems" do
      pending
#      get :index
#      response.should have_selector('div.pagination')
#      response.should have_selector('span.disabled', :content => "Previous")
#      response.should have_selector('a', :href => "/problems?page=2",
#                                         :content => "2")
#      response.should have_selector('a', :href => "/problems?page=2",
#                                         :content => "Next")
    end

    it "should have delete links" do
      get :index
      @user.problems.each do |problem|
        response.should have_selector('a', :href => problem_path(problem),
                                           :content => "delete")
      end
    end
    
    it "should have a link to create a new problem" do
      get :index
      response.should have_selector('a', :href => new_problem_path,
                                         :content => "New Problem?")
    end
  end

  describe "GET 'new'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "New problem")
    end

  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "success" do

      before(:each) do
        @attr = {
          :name => "Test Problem Name",
          :comment => "Test Problem Comment"
        }
      end

      it "should create a problem" do
        lambda do
          post :create, :problem => @attr
        end.should change(Problem, :count).by(1)
      end

      it "should redirect to the problem page" do
        post :create, :problem => @attr
        #this only works as long as there are no other problems for this user yet
        @problem = @user.problems.last
        response.should redirect_to(problem_path(@problem))
      end

      it "should have a flash message" do
        post :create, :problem => @attr
        flash[:success].should =~ /problem created/i
      end
    end

    describe "failure" do

      before(:each) do
        @attr = {
          :name => ""
        }
      end

      it "should not create a problem" do
        lambda do
          post :create, :problem => @attr
        end.should_not change(Problem, :count)
      end

      it "should render the new problem page" do
        post :create, :problem => @attr
        response.should render_template("problems/new")
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        @problem = Factory(:problem, :user => @user)
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        delete :destroy, :id => @problem
        response.should redirect_to(error_path)
      end

      it "should not destroy the problem" do
        lambda do
          delete :destroy, :id => @problem
        end.should_not change(Problem, :count)
      end

      it "should have a flash message" do
        delete :destroy, :id => @problem
        flash[:failure].should =~ /problem does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @problem = Factory(:problem, :user => @user)
      end

      it "should destroy the problem" do
        lambda do
          delete :destroy, :id => @problem
        end.should change(Problem, :count).by(-1)
      end

      describe "failure" do

        it "should have a flash message" do
          pending
          #TODO - how do I make it fail with a legit problem ID
          #delete :destroy, :id => @problem
          #flash[:failure].should =~ /error deleting problem/i
        end

        it "should render the problem page" do
          pending
          #TODO - how do I make it fail with a legit problem ID
          #delete :destroy, :id => @problem
          #response.should redirect_to(problem_path(@problem))
        end

        it "should render an error page when trying to access an invalid problem" do
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
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
          get :show, :id => @problem
        response.should redirect_to(error_path)
      end

      it "should have a flash message" do
          get :show, :id => @problem
        flash[:failure].should =~ /problem does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should be successful" do
          get :show, :id => @problem
          response.should be_success
        end

        it "should find the right problem" do
          get :show, :id => @problem
          assigns(:problem).should == @problem
        end

        it "should have the right title" do
          get :show, :id => @problem
          response.should have_selector("title", :content => @problem.name)
        end

        it "should have a link to the problem's page" do
          get :show, :id => @problem
          response.should have_selector("a", :content => "Problems")
        end

        it "should have a link to the edit page" do
          get :show, :id => @problem
          response.should have_selector("a", :content => "Edit Problem")
        end

        it "should have the problem's name'" do
          get :show, :id => @problem
          response.should have_selector("h1", :content => @problem.name)
        end

        it "should include the problem's comment" do
          get :show, :id => @problem
          response.should have_selector("span", :content => @problem.comment)
        end

        it "should have a link to the questions page" do
          get :show, :id => @problem
          response.should have_selector("a", :content => "View Questions")
        end
      end

      describe "failure" do

        it "should render an error page when trying to access an invalid problem" do
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
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        get :edit, :id => @problem
        response.should redirect_to(error_path)
      end

      it "should have a flash message" do
        get :edit, :id => @problem
        flash[:failure].should =~ /problem does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should be successful" do
          get :edit, :id => @problem
          response.should be_success
        end

        it "should find the right problem" do
          get :edit, :id => @problem
          assigns(:problem).should == @problem
        end

        it "should have the right title" do
          get :edit, :id => @problem
          response.should have_selector("title", :content => "Edit problem")
        end

        pending "it should show the existing attributes in the fields"
      end

      describe "failure" do

        it "should render an error page when trying to access an invalid problem" do
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
      @attr = {
          :name => "Updated Problem Name",
          :comment => "Updated comment"
      }
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        put :update, :id => @problem, :problem => @attr
        response.should redirect_to(error_path)
      end

      it "should not edit the problem" do
        put :update, :id => @problem, :problem => @attr
        @problem.reload
        @problem.name.should_not == @attr[:name]
        @problem.comment.should_not == @attr[:comment]
      end

      it "should have a flash message" do
        put :update, :id => @problem, :problem => @attr
        flash[:failure].should =~ /problem does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should change the problem's attributes" do
          put :update, :id => @problem, :problem => @attr
          @problem.reload
          @problem.name.should == @attr[:name]
          @problem.comment.should == @attr[:comment]
        end

        it "should redirect to the problem page" do
          put :update, :id => @problem, :problem => @attr
          response.should redirect_to(problem_path)
        end

        it "should have a flash message" do
          put :update, :id => @problem, :problem => @attr
          flash[:success].should =~ /problem updated/i
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
#          put :update, :id => @problem, :problem => @bad_attr
#          flash[:failure].should =~ /error updating problem/i
        end

        it "should render the problem page" do
          put :update, :id => @problem, :problem => @bad_attr
          response.should render_template("problems/edit")
        end
        
        it "should not edit the problem" do
          put :update, :id => @problem, :problem => @bad_attr
          @problem.reload
          @problem.name.should_not == @bad_attr[:name]
          @problem.comment.should_not == @bad_attr[:comment]
        end

        it "should render an error page when trying to access an invalid problem" do
          put :update, :id => 1000, :problem => @attr
          response.should redirect_to(error_path)
        end
      end
    end
  end
end
