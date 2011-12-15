require 'spec_helper'

describe "Problems" do

  before(:each) do
    user = Factory(:user)
    integration_sign_in(user)
  end

  describe "creation" do

    describe "failure" do

      it "should not make a new problem" do
        lambda do
          visit root_path
          fill_in :problem_name, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Problem, :count)
      end
    end

    describe "success" do

      it "should make a new problem" do
        name = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :problem_name, :with => name
          click_button
          response.should have_selector("span.name", :solution_name => name)
        end.should change(Problem, :count).by(1)
      end
    end
  end
end