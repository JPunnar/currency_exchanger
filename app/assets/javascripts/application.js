//= require jquery
//= require rails-ujs
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require Chart.bundle
//= require chartkick
//= require_tree .
//= require_self

$( document ).on('turbolinks:load', function() {
  if ($("input[type=range]").length > 0) {
    range_field = $("input[type=range]");
    range_field.val(1);
    range_field.on('input', function () {
        $("#rangeFieldVal").text(range_field.val());
    });

    //
    // the point of this js is to not let user
    // select same currency for base and target
    //
    var previous = '';
    $("select").on('focus', function () {
        previous = $(this).val();
    }).change(function() {
        // removing selected value from other select
        if ($(this).val() != '') {
          $("select").not(this).find("option[value="+ $(this).val() + "]").remove();
        }
        // adding previous value back to other select
        if (previous != '') {
          $("select").not(this).prepend($('<option>', {
              value: previous,
              text: previous
          }));
        }
        previous = this.value;
    });
  }
});