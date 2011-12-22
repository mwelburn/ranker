require 'spec_helper'

describe AnswersController do
  render_views

  describe "access control" do

    before(:each) do
      @user = Factory(:user)
      @problem = Factory(:problem, :user => @user)
      @solution = Factory(:solution, :problem => @problem)
      @question = Factory(:question, :problem => @problem)
      @answer = Factory(:answer, :solution => @solution, :question => @question)
    end

    it "should deny access to 'create'" do
      post :create, :question_id => @question.id, :solution_id => @solution.id
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'update'" do
      put :update, :id => @answer, :answer => { :rating => 1 }
      response.should redirect_to(new_user_session_path)
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
          post :create, :question_id => @question.id, :solution => @attr
        end.should change(Solution, :count).by(1)
      end

      it "should not require a comment" do
        lambda do
          post :create, :question_id => @question.id, :solution => @attr.merge(:comment => "")
        end.should change(Solution, :count).by(1)
      end

      it "should redirect to the solution page" do
        post :create, :question_id => @question.id, :solution => @attr
        #this only works as long as there are no other solutions for this problem yet
        @solution = @problem.solutions.last
        response.should redirect_to(solution_path(@solution))
      end

      it "should have a flash message" do
        post :create, :question_id => @question.id, :solution => @attr
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
          post :create, :question_id => @question.id, :solution => @attr
        end.should_not change(Solution, :count)
      end

      it "should render the new solution page" do
        post :create, :question_id => @question.id, :solution => @attr
        response.should render_template("solutions/new")
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
end
