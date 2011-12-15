module ApplicationHelper

  def title
    base_title = "Ranker"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("logo.png", :alt => "Ranker", :class => "round")
  end
  
end
