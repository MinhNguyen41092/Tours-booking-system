$(document).on('turbolinks:load', function() {
  $('#review-link').click(function(event) {
    event.preventDefault();
    $('#review-form').fadeToggle();
  });
});
