require 'spec_helper'

describe ProblemsController do
  render_views

  describe "access control" do

    it "should deny access to 'index'" do
      get :index
      response.should redirect_to(new_user_session_path)
    end

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

    it "should deny access to 'edit'" do
      get :edit, :id => 1
      response.should redirect_to(new_user_session_path)
    end
  end

  descruibe "GET 'index'" do

    before(:each) do
      @user1 = test_sign_in(Factory(:user))
      @user2 = Factory(:user, :email => Factory.next(:email))
      @attr = {
          :name => "Problem Name",
          :comment => "Problem Comment"
      }
      @problem1 = @user1.problems.create!(@attr)
      @problem2 = @user1.problems.create!(@attr.merge(:name => "Second Problem"))
      @problem3 = @user2.problems.create!(@attr.merge(:name => "Other problem"))
    end

    it "should display the user's problems" do
      pending
    end

    it "should not display other user's problems'" do
      pending
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
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

      it "should render the home page" do
        post :create, :problem => @attr
        response.should render_template("pages/home")
      end
    end

    describe "success" do

      before(:each) do
        @attr = {
          :name => "Lorem ipsum"
        }
      end

      it "should create a problem" do
        lambda do
          post :create, :problem => @attr
        end.should change(Problem, :count).by(1)
      end

      it "should redirect to the problem page" do
        post :create, :problem => @attr
        response.should redirect_to(problem_path)
      end

      it "should have a flash message" do
        post :create, :problem => @attr
        flash[:success].should =~ /problem created/i
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
      end

      it "should deny access" do
        delete :destroy, :id => @problem
        response.should redirect_to(root_path)
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
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @problem = Factory(:problem, :user => @user)
    end

    it "should be successful" do
      get :show, :id => @problem
      response.should be_success
    end

    it "should find the right problem" do
      get :show, :id => @problem
      assigns(:problem).should == @problem
    end

    it "should have the right title'" do
      get :show, :id => @problem
      response.should have_selector("title", :content => @problem.name)
    end

    it "should have the problem's name'" do
      get :show, :id => @problem
      response.should have_selector("h1", :content => @problem.name)
    end

    it "should include the problem's comment" do
      get :show, :id => @problem
      response.should have_selector("p", :content => @problem.comment)
    end

    pending "implement showing questions"

    pending "implement showing solutions"

    describe "authorization" do

      it "should not return another user's problem" do
        pending
      end

      it "should redirect to the home page with a warning when trying to view another user's problem" do
        pending
      end
    end
  end

  describe "GET 'edit'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @problem = Factory(:problem, :user => @user)
    end

    it "should be successful do" do
      get :edit, :id => @problem
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @problem
      response.should have_selector("title", :content => "Edit problem")
    end
  end
end
