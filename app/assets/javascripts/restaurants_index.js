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
   var counter = 0;
   $(document).on('ajaxComplete', function() {
      counter += 1;
      if (counter >= 4) {
        leftEmpty();
        rightEmpty();
      }
   })
 });

function foodTypeRequest1(typeOfFood) {
  showLoader();
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
  $(".header-left").empty()
  var counting = $(".left .restaurant-card").size();
  if (counting == 0) {
    $(".header-left").append("<h3>" + counting + " restaurants found<h3>");
  } else {
    $(".header-left").append("<h3>" + counting + " restaurants found<h3>");
  }
}

function countRestoRight() {
  $(".header-right").empty()
  var counting = $(".right .restaurant-card").size();
  if (counting == 0) {
    $(".header-right").append("<h3>" + counting + " restaurants found<h3>");
  } else {
    $(".header-right").append("<h3>" + counting + " restaurants found<h3>");
  }
}

function leftEmpty() {
  if ($('.step-1 .left').children().length == 0){
    $('.step-1 .left').append("<p>Aww, there's no match for this delivery time, check below if next one matches !</p>");
  }
  if ($('.step-2 .left').children().length == 0) {
    $('.step-2 .left').append("<p>Aww, there's no match for this delivery time, check below if next one matches !</p>");
  }
  if ($('.step-3 .left').children().length == 0) {
    $('.step-3 .left').append("<p>Aww, there's no match for this delivery time, check below if next one matches !</p>");
  }
}


function rightEmpty() {
  if ($('.step-1 .right').children().length == 0){
    $('.step-1 .right').append("<p>Aww, there's no match for this delivery time, check below if next one matches !</p>");
  }
  if ($('.step-2 .right').children().length == 0) {
    $('.step-2 .right').append("<p>Aww, there's no match for this delivery time, check below if next one matches !</p>");
  }
  if ($('.step-3 .right').children().length == 0) {
    $('.step-3 .right').append("<p>Aww, there's no match for this delivery time, check below if next one matches !</p>");
  }
}

function revealMenusButton() {
  if ($("input:checked").size() >= 1) {
    $("#show-submit").addClass("visible");
  }
  if ($("input:checked").size() == 1) {
    $("#button-eat").prop("disabled", true);
  }
  if ($("input:checked").size() == 2) {
    $("#button-eat").prop("disabled", false);
    $("#two-menus").addClass("fadeOut");
  }
}

function checkLoader() {
  console.log($.active);
  if ($.active == 1) {
    $('#restaurants-list').show();
    $(".menu-animation-wrapper").hide();
  };
}

function showLoader() {
  $('#restaurants-list').hide();
  $(".menu-animation-wrapper").show();
}


