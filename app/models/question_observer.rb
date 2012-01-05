class QuestionObserver < ActiveRecord::Observer

  def after_create(question)
    problem = question.problem
    problem.invalidate_solutions
  end

  def after_save(question)
    problem = question.problem
    #need to reload the cache
    problem.questions.reload

    problem.update_question_total
  end

  def after_destroy(question)
    problem = question.problem
    #need to reload the cache
    problem.questions.reload

    problem.update_question_total
    problem.update_solutions
  end

end
