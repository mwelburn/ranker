require 'spec_helper'

describe "Solutions" do

  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)
    @problem = Factory(:problem, :user => @user)
  end

  describe "creation" do

    describe "failure" do

      it "should not make a new solution" do
        lambda do
          visit new_problem_solution_path(@problem)
          fill_in :solution_name, :with => ""
          fill_in :solution_comment, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Solution, :count)
      end
    end

    describe "success" do

      it "should make a new solution" do
        name = "Solution name"
        comment = "Solution comment"
        lambda do
          visit new_problem_solution_path(@problem)
          fill_in :solution_name, :with => name
          fill_in :solution_comment, :with => comment
          click_button
          response.should have_selector("span.name", :solution_name => name)
        end.should change(Solution, :count).by(1)
      end
    end
  end
end