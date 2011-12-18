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
          fill_in :problem_comment, :with => ""
          click_button
          response.should render new_problem_path
          response.should have_selector("div#error_explanation")
        end.should_not change(Problem, :count)
      end
    end

    describe "success" do

      it "should make a new problem" do
        name = "Fake name"
        comment = "Fake comment"
        lambda do
          visit root_path
          fill_in :problem_name, :with => name
          fill_in :problem_name, :with => comment
          click_button
          #todo - should redirect to problem
          response.should have_selector("span.name", :solution_name => name)
          #todo - should have success message
        end.should change(Problem, :count).by(1)
      end
    end
  end
end