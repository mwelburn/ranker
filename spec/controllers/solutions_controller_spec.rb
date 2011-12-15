require 'spec_helper'

describe SolutionsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'show'" do
      get :show, :id => 1
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @problem = Factory(:problem, :user => @user)
    end

    describe "failure" do

      before(:each) do
        @attr = {
          :name => "",
          :problem_id => @problem.id
        }
      end

      it "should not create a solution" do
        lambda do
          post :create, :solution => @attr
        end.should_not change(Solution, :count)
      end

      it "should render the home page" do
        post :create, :solution => @attr
        response.should render_template("pages/home")
      end
    end

    describe "success" do

      before(:each) do
        @attr = {
          :name => "Lorem ipsum",
          :problem_id => @problem.id
        }
      end

      it "should create a problem" do
        lambda do
          post :create, :solution => @attr
        end.should change(Solution, :count).by(1)
      end

      it "should redirect to the solution page" do
        post :create, :solution => @attr
        response.should redirect_to(solution_path)
      end

      it "should have a flash message" do
        post :create, :solution => @attr
        flash[:success].should =~ /solution created/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @problem = Factory(:problem, :user => @user)
        @solution = Factory(:solution, :problem => @problem)
      end

      it "should deny access" do
        delete :destroy, :id => @solution
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @problem = Factory(:problem, :user => @user)
        @solution = Factory(:solution, :problem => @problem)
      end

      it "should destroy the solution" do
        lambda do
          delete :destroy, :id => @solution
        end.should change(Solution, :count).by(-1)
      end
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @problem = Factory(:problem, :user => @user)
      @solution = Factory(:solution, :problem => @problem)
    end

    it "should be successful" do
      get :show, :id => @solution
      response.should be_success
    end

    it "should find the right solution" do
      get :show, :id => @solution
      assigns(:solution).should == @solution
    end

    it "should have the right title'" do
      get :show, :id => @solution
      response.should have_selector("title", :content => @solution.name)
    end

    it "should have the solution's name" do
      get :show, :id => @solution
      response.should have_selector("h1", :content => @solution.name)
    end

    it "should include the solution's comment" do
      get :show, :id => @solution
      response.should have_selector("p", :content => @solution.comment)
    end

    it "should have the solutions's ranking" do
      get :show, :id => @solution
      response.should have_selector("h1", :content => @solution.ranking)
    end

    pending "implement showing answers"

    pending "implement showing questions"

    pending "implement showing solutions"
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @problem = Factory(:problem, :user => @user)
      @solution = Factory(:solution, :problem => @problem)
    end

    it "should be successful do" do
      get :edit, :id => @solution
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @solution
      response.should have_selector("title", :content => "Edit solution")
    end
  end
end
