// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(document).ready(function(){
    $('span#add_question').click(function() {
        var $new_question = $('#questions li:first').clone();

        //clear existing inputs
        $new_question.find('input').val('')

        //re-set the IDs


        //hide the question
        $new_question.hide();

        //append the question to the stack
        $new_question.appendTo('#questions');

        //display question via animation
        $new_question.slideDown()
    });
});