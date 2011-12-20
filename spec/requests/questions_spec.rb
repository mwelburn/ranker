require 'spec_helper'

describe "Questions" do

  before(:each) do
    @user = Factory(:user)
    integration_sign_in(@user)
    @problem = Factory(:problem, :user => @user)
  end

  describe "creation" do

    describe "failure" do

      it "should not make a new question" do
        lambda do
          visit new_problem_question_path(@problem)
          fill_in :question_text, :with => ""
          fill_in :question_weight, :with => ""
          click_button
          response.should render_template("questions/new")
          response.should have_selector("div#error_explanation")
        end.should_not change(Question, :count)
      end
    end

    describe "success" do

      it "should make a new question" do
        text = "Fake text"
        weight = 1
        lambda do
          visit new_problem_question_path(@problem)
          fill_in :question_text, :with => text
          fill_in :question_weight, :with => weight
          click_button
          response.should render_template("questions/show")
          response.should have_selector("span#text", :content => text)
        end.should change(Question, :count).by(1)
      end
    end
  end
end