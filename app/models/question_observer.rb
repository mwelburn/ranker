class QuestionObserver < ActiveRecord::Observer

  def after_create(question)
    problem = question.problem
    problem.update_question_total
    problem.invalidate_solutions
  end

  def after_save(question)
    problem = question.problem
    problem.update_question_total
  end
  
end
