$(document).ready(function() {
  if ($('#restaurants-list').length > 0) {
      var foodType1 = $('#selection_food_type_1').val();
      var foodType2 = $('#selection_food_type_2').val();
      foodTypeRequest1(foodType1);
      foodTypeRequest2(foodType2);
      $('#selection_food_type_1').on('change', function() {
        var foodType = $('#selection_food_type_1').val();
        $(".left").empty();
        foodTypeRequest1(foodType);
      });
      $('#selection_food_type_2').on('change', function() {
        var foodType = $('#selection_food_type_2').val();
        $(".right").empty();
        foodTypeRequest2(foodType);
      });

      $('#restaurants-form').on('change', function() {
        $('input:not(:checked)').parent().parent().removeClass("selected-card");
        $("input:checked").parent().parent().addClass("selected-card");
        revealMenusButton()
      });
   }
 });

function foodTypeRequest1(typeOfFood) {
  showLoader();
  $(".empty-no-match").hide();
  $.ajax({
    type: 'GET',
    url: '/foodora?food_type=' + typeOfFood,
    success: function(response) {
      $(response).filter(".restaurant-card").each(function(index, resto) {
        var step = $(resto).data('step');
        $("." + step + ' .left').append($(resto));
        $('.left .posting-menu').attr('name', 'left_url');
       });
      countRestoLeft();
      checkLoader();
    }
  })
  $.ajax({
    type: 'GET',
    url: '/deliveroo?food_type=' + typeOfFood,
    success: function(response) {
      $(response).filter(".restaurant-card").each(function(index, resto) {
        var step = $(resto).data('step');
        $("." + step + " .left").append($(resto));
        $('.left .posting-menu').attr('name', 'left_url');
      });
      countRestoLeft();
      checkLoader();
    }
  })
}

function foodTypeRequest2(typeOfFood) {
  showLoader();
  $(".empty-no-match").hide();
  $.ajax({
    type: 'GET',
    url: '/foodora?food_type=' + typeOfFood,
    success: function(response) {
      $(response).filter(".restaurant-card").each(function(index, resto) {
        var step = $(resto).data('step');
        $("." + step + ' .right').append($(resto));
        $('.right .posting-menu').attr('name', 'right_url');
      });
      countRestoRight();
      checkLoader();
    }
  })
  $.ajax({
    type: 'GET',
    url: '/deliveroo?food_type=' + typeOfFood,
    success: function(response) {
      $(response).filter(".restaurant-card").each(function(index, resto) {
        var step = $(resto).data('step');
        $("." + step + ' .right').append($(resto));
        $('.right .posting-menu').attr('name', 'right_url');
      });
      countRestoRight();
      checkLoader();
    }
  })
}

function countRestoLeft() {
  $(".header-left").empty();
  var counting = $(".left .restaurant-card").size();
  if (counting == 0) {
    $(".header-left").append("<p><strong>" + counting + "</strong> restaurants found<p>");
  } else {
    $(".header-left").append("<p><strong>" + counting + "</strong> restaurants found<p>");
  }
}

function countRestoRight() {
  $(".header-right").empty()
  var counting = $(".right .restaurant-card").size();
  if (counting == 0) {
    $(".header-right").append("<p><strong>" + counting + "</strong> restaurants found<p>");
  } else {
    $(".header-right").append("<p><strong>" + counting + "</strong> restaurants found<p>");
  }
}

function leftEmpty() {
  if ($('.step-1 .left').children().length == 0) {
    $("#no-match-wrapper-1-left").show()
  }
  if ($('.step-2 .left').children().length == 0) {
    $("#no-match-wrapper-2-left").show()
  }
  if ($('.step-3 .left').children().length == 0) {
    $("#no-match-wrapper-3-left").show()
  }
}


function rightEmpty() {
  if ($('.step-1 .right').children().length == 0){
    $("#no-match-wrapper-1-right").show()
  }
  if ($('.step-2 .right').children().length == 0) {
    $("#no-match-wrapper-2-right").show()
  }
  if ($('.step-3 .right').children().length == 0) {
    $("#no-match-wrapper-3-right").show()
  }
}

function revealMenusButton() {

// With button directly in navbar

  if ($("input:checked").size() >= 1) {
    $("#button-eat").css({ opacity: 1 });
  }

  if ($("input:checked").size() == 2) {
    $("#button-eat").prop("disabled", false);
  }

  if ($("input:checked").size() == 1) {
    $("#button-eat").prop("disabled", true);
  }

// With bottom-bar opening

  // if ($("input:checked").size() >= 1) {
  //   $("#show-submit").addClass("visible");
  // }
  // if ($("input:checked").size() == 1) {
  //   $("#button-eat").prop("disabled", true);
  // }
  // if ($("input:checked").size() == 2) {
  //   $("#button-eat").prop("disabled", false);
  //   $("#two-menus").addClass("fadeOut");
  // }
}

function checkLoader() {
  if ($.active == 1) {
    $('#restaurants-list').show();
    $(".menu-animation-wrapper").hide();
    leftEmpty();
    rightEmpty();
  };
}

function showLoader() {
  $('#restaurants-list').hide();
  $(".menu-animation-wrapper").show();
}


