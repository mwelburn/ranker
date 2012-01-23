module ApplicationHelper

  def title
    base_title = "Residency Ranker"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("logo.png", :alt => "Residency Ranker", :class => "round")
  end

end
