function enhanceFoodoraUI() {
  $(".vendor-info .name").each(function() {
    var $resto = $(this);
    var $envoi = $resto.next();
    var restaurants_name = encodeURI($resto.text().replace(/^\s+|\s+$/g, ''));
    $.ajax({
      type: "GET",
      url: "https://localhost:3000/api/v1/restaurants/" + restaurants_name,
      success: function(data) {
        if (data.ranking != undefined) {
          $envoi.append($('<span>').text("・ note:" + " " + data.ranking));
        } else {
          $envoi.append($('<span>').text("・" + "" + " N/A"));
        }
      },
      error: function(jqXHR) {
        console.log('error')
      }
    });
  });
}

function enhanceDeliverooUI() {
  $(".restaurant-index-page-tile").each(function() {
    var $resto = $(this);
    var restaurants_name = encodeURI($resto.find('h3').text());
    $.ajax({
      type: "GET",
      url: "https://localhost:3000/api/v1/restaurants/" + restaurants_name,
      success: function(data) {
        if (data.ranking != undefined) {
          $resto.find('p').append($('<span>').text("・note:"+ " " + data.ranking)).css();
        } else {
          $resto.find('p').append($('<span>').text("・" + " " + "N/A"));
        }
      },
      error: function(jqXHR) {
        console.log('error')
      }
    });
  });
}

function isFoodora() {
  return /foodora/.test(window.location.href);
}

$(function() {
  if (isFoodora()) {
    enhanceFoodoraUI();
    $(document).on('page:load', function() { enhanceFoodoraUI(); });
  } else {
    enhanceDeliverooUI();
  }
});
