class AnswerObserver < ActiveRecord::Observer

  def after_save(answer)
    solution = answer.solution
    solution.validate_solution
    solution.update_answer_total
  end
  
end
