function enhanceFoodoraUI() {
  $("a[data-vendor]").each(function() {
    var $resto = $(this);
    var name = $resto.find('.name').text().replace(/^\s+|\s+$/g, '');
    $.ajax({
      type: "GET",
      url: "https://www.eatogether.uk/api/v1/restaurants/" + encodeURI(name),
      success: function(data) {
        if (data.ranking != undefined) {
          var stars = starsMarkup(data.ranking);
          $resto.find('picture').append(stars);
        }
      },
      error: function(jqXHR) {
        console.log('error');
      }
    });
  });
}

function enhanceDeliverooUI() {
  $(".restaurant-index-page-tile").each(function() {
    var $resto = $(this);
    var restaurants_name = encodeURI($resto.find('h3').text().replace(/^\s+|\s+$/g, ''));
    $.ajax({
      type: "GET",
      url: "https://www.eatogether.uk/api/v1/restaurants/" + restaurants_name,
      success: function(data) {
        if (data.ranking != undefined) {
          // $resto.find('p').append($('<span>').text("・note:"+ " " + data.ranking)).css();
          var stars = starsMarkup(data.ranking);
          $resto.find('.restaurant-index-page-tile--top').append(stars);
        }
      },
      error: function(jqXHR) {
        console.log('error');
      }
    });
  });
}

function starsMarkup(ranking) {
  console.log(ranking);
  var html = "<div class='stars-wrapper'>";
  for (var i = 0; i < 5; i++) {
    if (ranking >= i + 1) {
      html += '<span class="star-icon full">☆</span>';
    } else if (ranking > i) {
      html += '<span class="star-icon half">☆</span>';
    } else {
      html += '<span class="star-icon">☆</span>';
    }
  }
  html += '</div>';
  console.log(html);
  return html;
}

function isFoodora() {
  return /foodora/.test(window.location.href);
}

$(function() {
  $('head').append("<style>.stars-wrapper{background:rgba(255,255,255,0.8);position:absolute;bottom:0;left:0;z-index:5;}.star-icon{padding:0 1px;position:relative;color:#aaa;font-size:1.5em;}.star-icon.full:before{text-shadow:0 0 2px rgba(0,0,0,0.7);color:#FDE16D;content:'\\2605';position:absolute;left:0}.star-icon.half:before{text-shadow:0 0 2px rgba(0,0,0,0.7);color:#FDE16D;content:'\\2605';position:absolute;left:0;width:50%;overflow:hidden}@-moz-document url-prefix(){.star-icon { font-size:50px;line-height:34px}</style>");
  if (isFoodora()) {
    enhanceFoodoraUI();
    $(document).on('page:load', function() { enhanceFoodoraUI(); });
  } else {
    enhanceDeliverooUI();
  }
});
