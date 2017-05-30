$(function() {
  if ($('#restaurants-list').length > 0) {
    $.ajax({
      type: 'GET',
      url: '/foodora',
      success: function(response) {
        $('#restaurants-list').append(response);
      }
    })
  }
});
