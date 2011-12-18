require 'spec_helper'

describe "Solutions" do

  before(:each) do
    user = Factory(:user)
    integration_sign_in(user)
    problem_attr = {
      :name => "Example Problem",
      :comment => "Example comments"
    }
    @problem = integration_create_problem(problem_attr)
  end
=begin
  describe "creation" do

    describe "failure" do

      it "should not make a new solution" do
        lambda do
          visit @problem
          fill_in :solution_name, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Problem, :count)
      end
    end

    describe "success" do

      it "should make a new solution" do
        name = "Lorem ipsum dolor sit amet"
        lambda do
          visit @problem
          fill_in :solution_name, :with => name
          click_button
          response.should have_selector("span.name", :solution_name => name)
        end.should change(Problem, :count).by(1)
      end
    end
  end
=end
end