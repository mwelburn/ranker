require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ranker"
  end

  describe "GET 'home'" do
    
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title", :content => @base_title + " | Home")
    end

    describe "authenticated" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @other_user = Factory(:user, :email => Factory.next(:email))

        30.times do
          Factory(:problem, :user => @user,
                            :name => Factory.next(:name))
        end
        @other_problem = Factory(:problem, :user => @other_user, :name => "Other problem")
      end

      it "should have an element for each user's problem" do
        get 'home'
        @user.problems.paginate(:page => 1).each do |problem|
          response.should have_selector('td', :content => problem.name)
        end
      end

      #this test requires the problem's not have the same name
      it "should not contain other user's problems" do
        get 'home'
        @other_user.problems.paginate(:page => 1).each do |problem|
          response.should_not have_selector('td', :content => problem.name)
        end
      end
=begin
    #TODO - find a pagination gem that works in 3.1
      it "should paginate problems" do
        get 'home'
        response.should have_selector('div.pagination')
        response.should have_selector('span.disabled', :content => "Previous")
        response.should have_selector('a', :href => "/problems?page=2",
                                           :content => "2")
        response.should have_selector('a', :href => "/problems?page=2",
                                           :content => "Next")
      end
=end
      it "should have delete links" do
        get 'home'
        @user.problems.paginate(:page => 1).each do |problem|
          response.should have_selector('a', :href => problem_path(problem),
                                             :content => "delete")
        end
      end

      it "should have show links" do
        get 'home'
        @user.problems.paginate(:page => 1).each do |problem|
          response.should have_selector('a', :href => problem_path(problem),
                                             :content => problem.name)
        end
      end

      it "should have a link to create a new problem" do
        get 'home'
        response.should have_selector('a', :href => new_problem_path,
                                           :content => "New Problem?")
      end
    end
  end
  
  describe "GET 'about'" do
    
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title", :content => @base_title + " | About")
    end
  end
  
  describe "GET 'contact'" do
    
    it "should be successful" do
      get'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title", :content => @base_title + " | Contact")
    end
  end

  describe "GET 'help'" do

    it "should be successful" do
      get'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title", :content => @base_title + " | Help")
    end
  end
end
