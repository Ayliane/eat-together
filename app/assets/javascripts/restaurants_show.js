$(document).ready(function() {
  if ($('#show-general').length > 0) {
      var leftUrl = $('#left_url').val();
      var rightUrl = $('#right_url').val();

      menuRequest1(leftUrl);
      menuRequest2(rightUrl);
   }
 });

function menuRequest1(url) {
  if (/foodora/.test(url)) {
    $.ajax({
      type: 'GET',
      url: '/foodora_show?url=' + url,
      success: function(response) {
        $('#menu_1').html(response);
      }
    });
   } else {
    $.ajax({
      type: 'GET',
      url: '/deliveroo_show?url=' + url,
      success: function(response) {
        $('#menu_1').html(response);
      }
    })
  }
}

function menuRequest2(url) {
  if (/foodora/.test(url)) {
    $.ajax({
      type: 'GET',
      url: '/foodora_show?url=' + url,
      success: function(response) {
        $('#menu_2').html(response);
      }
    });
   } else {
    $.ajax({
      type: 'GET',
      url: '/deliveroo_show?url=' + url,
      success: function(response) {
        $('#menu_2').html(response);
      }
    })
  }
}

