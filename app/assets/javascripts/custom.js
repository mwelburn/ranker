$(function() {
  $('form a.add_child').click(function() {
    var association = $(this).attr('data-association');
    var category_id = $(this).attr('category_id');
    var template = $('#' + association + '_fields_template_' + category_id).html();
    var regexp = new RegExp('new_' + association, 'g');
    var new_id = new Date().getTime();

    $(this).before(template.replace(regexp, new_id));
    //$(this).parent().before(template.replace(regexp, new_id));
    return false;
  });

  $('form a.remove_child').live('click', function() {
    var hidden_field = $(this).prev('input[type=hidden]')[0];
    if(hidden_field) {
      hidden_field.value = '1';
    }
    $(this).parents('.fields').hide();
    return false;
  });

  // Find ALL <form> tags on your page
  $('form').submit(function(){
    // On submit disable its submit button
    $('input[type=submit]', this).attr('disabled', 'disabled');
  });
});