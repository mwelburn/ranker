class AnswerObserver < ActiveRecord::Observer

  def after_save(answer)
    solution = answer.solution
    solution.answers.reload

    solution.validate_solution
    solution.update_answer_total
  end
  
end
