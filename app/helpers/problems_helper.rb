module ProblemsHelper

  def new_child_fields_template(form_builder, association, options = {})
    category_id = options[:category_id]
    category_id ||= ""
    options[:object] ||= form_builder.object.class.reflect_on_association(association).klass.new(:category_id => category_id)
    options[:partial] ||= association.to_s.singularize
    options[:form_builder_local] ||= :f

    content_for :jstemplates do
      content_tag(:div, :id => "#{association}_fields_template_#{category_id}", :style => "display: none") do
        form_builder.fields_for(association, options[:object], :child_index => "new_#{association}") do |f|
          render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
        end
      end
    end
  end

  def add_child_link(name, association, options = {})
    category_id = options[:category_id]
    category_id ||= ""
    link_to(name, "javascript:void(0)", :class => "btn primary add_child", :"data-association" => association, :"category_id" => category_id)
  end

  def remove_child_link(name, f)
    f.hidden_field(:_destroy) + link_to(name, "javascript:void(0)", :class => "btn danger remove_child")
  end

end
