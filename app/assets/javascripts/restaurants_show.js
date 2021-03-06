$(document).ready(function() {
  if ($('#show-general').length > 0) {
      var leftUrl = $('#menu_left').data('url');
      var rightUrl = $('#menu_right').data('url');

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
        $('#menu_left').html(response);
        var name = $(response).filter('.menu-list').data('name');
        $('#restaurant_name_left').text(name);
        var rank = $(response).filter('.menu-list').data('rank');
        $('#ranking_left').text(rank);
      }
    });
   } else {
    $.ajax({
      type: 'GET',
      url: '/deliveroo_show?url=' + url,
      success: function(response) {
        $('#menu_left').html(response);
        var name = $(response).filter('.menu-list').data('name');
        $('#restaurant_name_left').text(name);
        var rank = $(response).filter('.menu-list').data('rank');
        $('#ranking_left').text(rank);
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
        $('#menu_right').html(response);
        var name = $(response).filter('.menu-list').data('name');
        $('#restaurant_name_right').text(name);
        var rank = $(response).filter('.menu-list').data('rank');
        $('#ranking_right').text(rank);
      }
    });
   } else {
    $.ajax({
      type: 'GET',
      url: '/deliveroo_show?url=' + url,
      success: function(response) {
        $('#menu_right').html(response);
        var name = $(response).filter('.menu-list').data('name');
        $('#restaurant_name_right').text(name);
        var rank = $(response).filter('.menu-list').data('rank');
        $('#ranking_right').text(rank);
      }
    })
  }
}
