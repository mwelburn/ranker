require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have a About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
  end

  describe "when not signed in" do

    it "should have a signin link" do
      visit root_path
      response.should have_selector("a", :href => new_user_session_path, :content => "Sign in")
    end

    it "should have a signup link" do
      visit root_path
      response.should have_selector("a", :href => new_user_registration_path, :content => "Sign up")
    end
  end

  describe "when signed in" do

    before(:each) do
      @user = Factory(:user)
      integration_sign_in(@user)
    end

    it "should have a signout link" do
      visit root_path
      response.should have_selector("a", :href => destroy_user_session_path, :content => "Sign out")
    end

    it "should have a settings link" do
      visit root_path
      response.should have_selector("a", :href => edit_user_registration_path, :content => "Settings")
    end
  end
end