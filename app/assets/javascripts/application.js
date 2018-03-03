//= require jquery
//= require rails-ujs
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .
//= require_self

$( document ).on('turbolinks:load', function() {
  if ($("input[type=range]").length > 0) {
    range_field = $("input[type=range]");
    range_field.val(1);
    range_field.on('input', function () {
        $("#rangeFieldVal").text(range_field.val());
    });
  }
});