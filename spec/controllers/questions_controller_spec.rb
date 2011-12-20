require 'spec_helper'

describe QuestionsController do
  render_views

  describe "access control" do

    before(:each) do
      @user = Factory(:user)
      @problem = Factory(:problem, :user => @user)
      @question = Factory(:question, :problem => @problem)
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
      delete :destroy, :id => @question
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'show'" do
      get :show, :id => @question
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'edit'" do
      get :edit, :id => @question
      response.should redirect_to(new_user_session_path)
    end

    it "should deny access to 'update'" do
      put :update, :id => @question, :question => { :text => "Updated Text" }
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'index'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @problem = Factory(:problem, :user => @user)

      30.times do
        Factory(:question, :problem => @problem,
                           :text => Factory.next(:text))
      end
      
      @other_problem = Factory(:problem, :user => @user, :name => "Other problem")
      @other_question = Factory(:question, :problem => @other_problem, :text => "Other problem's question")
    end

    it "should be successful" do
      get :index, :problem_id => @problem.id
      response.should be_success
    end

    it "should have the right title" do
      get :index, :problem_id => @problem.id
      response.should have_selector('title', :content => "All questions")
    end

    it "should have an element for each problem's question" do
      get :index, :problem_id => @problem.id
      @problem.questions.each do |question|
        response.should have_selector('li', :content => question.text)
        #TODO - add weight
        #response.should have_selector('span.weight', :content => question.weight)
      end
    end

    #this test requires the question's not have the same text
    it "should not contain other problem's question" do
      get :index, :problem_id => @problem.id
      @other_problem.questions.each do |question|
        response.should_not have_selector('li', :content => question.text)
      end
    end

    #TODO - find a pagination gem that works in 3.1
    it "should paginate questions" do
      pending
#      get :index, :problem_id => @problem.id
#      response.should have_selector('div.pagination')
#      response.should have_selector('span.disabled', :content => "Previous")
#      response.should have_selector('a', :href => "/questions?page=2",
#                                         :content => "2")
#      response.should have_selector('a', :href => "/questions?page=2",
#                                         :content => "Next")
    end

    it "should have delete links" do
      get :index, :problem_id => @problem.id
      @problem.questions.each do |question|
        response.should have_selector('a', :href => question_path(question),
                                           :content => "delete")
      end
    end

    it "should have a link to create a new question" do
      get :index, :problem_id => @problem.id
      response.should have_selector('a', :href => new_problem_question_path(@problem),
                                         :content => "New Question?")
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
      response.should have_selector('title', :content => "New question")
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
          :text => "Test Question Text",
          :weight => 1
        }
      end

      it "should create a question" do
        lambda do
          post :create, :problem_id => @problem.id, :question => @attr
        end.should change(Question, :count).by(1)
      end

      it "should not require a weight" do
        lambda do
          post :create, :problem_id => @problem.id, :question => @attr.merge(:weight => "")
        end.should change(Question, :count).by(1)
      end

      it "should redirect to the question page" do
        post :create, :problem_id => @problem.id, :question => @attr
        #this only works as long as there are no other questions for this problem yet
        @question = @problem.questions.last
        response.should redirect_to(question_path(@question))
      end

      it "should have a flash message" do
        post :create, :problem_id => @problem.id, :question => @attr
        flash[:success].should =~ /question created/i
      end
    end

    describe "failure" do

      before(:each) do
        @attr = {
          :text => ""
        }
      end

      it "should not create a question" do
        lambda do
          post :create, :problem_id => @problem.id, :question => @attr
        end.should_not change(Question, :count)
      end

      it "should render the new question page" do
        post :create, :problem_id => @problem.id, :question => @attr
        response.should render_template("questions/new")
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        @problem = Factory(:problem, :user => @user)
        @question = Factory(:question, :problem => @problem)
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        delete :destroy, :id => @question
        response.should redirect_to(error_path)
      end

      it "should not destroy the question" do
        lambda do
          delete :destroy, :id => @question
        end.should_not change(Question, :count)
      end

      it "should have a flash message" do
        delete :destroy, :id => @question
        flash[:failure].should =~ /question does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @problem = Factory(:problem, :user => @user)
        @question = Factory(:question, :problem => @problem)
      end

      describe "success" do

        it "should destroy the question" do
          lambda do
            delete :destroy, :id => @question
          end.should change(Question, :count).by(-1)
        end
      end

      describe "failure" do

        it "should have a flash message" do
          pending
          #TODO - how do I make it fail with a legit question ID
          #delete :destroy, :id => @question
          #flash[:failure].should =~ /error deleting question/i
        end

        it "should render the problem page" do
          pending
          #TODO - how do I make it fail with a legit question ID
          #delete :destroy, :id => @question
          #response.should redirect_to(question_path(@question))
        end

        it "should render an error page when trying to access an invalid question" do
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
      @question = Factory(:question, :problem => @problem)
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        get :show, :id => @question
        response.should redirect_to(error_path)
      end

      it "should have a flash message" do
        get :show, :id => @question
        flash[:failure].should =~ /question does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should be successful" do
          get :show, :id => @question
          response.should be_success
        end

        it "should find the right question" do
          get :show, :id => @question
          assigns(:question).should == @question
        end

        it "should have the right title" do
          get :show, :id => @question
          response.should have_selector("title", :content => @question.text)
        end

        it "should have a link to the questions page" do
          get :show, :id => @question
          response.should have_selector("a", :content => "Questions")
        end

        it "should have a link to the edit question page" do
          get :show, :id => @question
          response.should have_selector("a", :content => "Edit Question")
        end

        it "should have the question's text" do
          get :show, :id => @question
          response.should have_selector("h1", :content => @question.text)
        end

        it "should include the question's weight" do
          get :show, :id => @question
          response.should have_selector("span", :content => @question.weight)
        end
      end

      describe "failure" do

        it "should render an error page when trying to access an invalid question" do
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
      @question = Factory(:question, :problem => @problem)
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        get :edit, :id => @question
        response.should redirect_to(error_path)
      end

      it "should have a flash message" do
        get :edit, :id => @question
        flash[:failure].should =~ /question does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should be successful" do
          get :edit, :id => @question
          response.should be_success
        end

        it "should find the right question" do
          get :edit, :id => @question
          assigns(:question).should == @question
        end

        it "should have the right title" do
          get :edit, :id => @question
          response.should have_selector("title", :content => "Edit question")
        end

        pending "it should show the existing attributes in the fields"
      end

      describe "failure" do

        it "should render an error page when trying to access an invalid question" do
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
      @question = Factory(:question, :problem => @problem)
      @attr = {
          :text => "Updated Question Text",
          :weight => 2
      }
    end

    describe "for an unauthorized user" do

      before(:each) do
        invalid_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(invalid_user)
      end

      it "should deny access" do
        put :update, :id => @question, :question => @attr
        response.should redirect_to(error_path)
      end

      it "should not edit the question" do
        put :update, :id => @question, :question => @attr
        @question.reload
        @question.text.should_not == @attr[:text]
        @question.weight.should_not == @attr[:weight]
      end

      it "should have a flash message" do
        put :update, :id => @question, :question => @attr
        flash[:failure].should =~ /question does not exist/i
      end
    end

    describe "for an authorized user" do

      before(:each) do
        test_sign_in(@user)
      end

      describe "success" do

        it "should change the question's attributes" do
          put :update, :id => @question, :question => @attr
          @question.reload
          @question.text.should == @attr[:text]
          @question.weight.should == @attr[:weight]
        end

        it "should redirect to the question page" do
          put :update, :id => @question, :question => @attr
          response.should redirect_to(question_path)
        end

        it "should have a flash message" do
          put :update, :id => @question, :question => @attr
          flash[:success].should =~ /question updated/i
        end
      end

      describe "failure" do

        before(:each) do
          @bad_attr = {
              :text => "",
              :weight => "" #weight can be blank, but text cannot
          }
        end

        it "should have a flash message" do
          pending
#          put :update, :id => @question, :question => @bad_attr
#          flash[:failure].should =~ /error updating question/i
        end

        it "should render the question page" do
          put :update, :id => @question, :question => @bad_attr
          response.should render_template("questions/edit")
        end

        it "should not edit the question" do
          put :update, :id => @question, :question => @bad_attr
          @question.reload
          @question.text.should_not == @bad_attr[:text]
          @question.weight.should_not == @bad_attr[:weight]
        end

        it "should render an error page when trying to access an invalid question" do
          put :update, :id => 1000, :question => @attr
          response.should redirect_to(error_path)
        end
      end
    end
  end
end
