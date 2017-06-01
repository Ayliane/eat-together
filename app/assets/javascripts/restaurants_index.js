$(document).ready(function() {
  if ($('#restaurants-list').length > 0) {
      var foodType1 = $('#food_type_1').val();
      var foodType2 = $('#food_type_2').val();
      foodTypeRequest1(foodType1);
      foodTypeRequest2(foodType2);
      $('#selection_food_type_1').on('change', function() {
        var foodType = $('#selection_food_type_1').val();
        $("#restaurants-list").empty();
        foodTypeRequest1(foodType);
      });
      $('#selection_food_type_2').on('change', function() {
        var foodType = $('#selection_food_type_2').val();
        $("#restaurants-list-2").empty();
        foodTypeRequest2(foodType);
      });
   }
 });

function foodTypeRequest1(typeOfFood) {
    $.ajax({
       type: 'GET',
       url: '/foodora?food_type=' + typeOfFood,
       success: function(response) {
         $('#restaurants-list').append(response);
       }
     })
     $.ajax({
      type: 'GET',
      url: '/deliveroo?food_type=' + typeOfFood,
      success: function(response) {
        $('#restaurants-list').append(response);
      }
     })
}

function foodTypeRequest2(typeOfFood) {
     $.ajax({
       type: 'GET',
       url: '/foodora?food_type=' + typeOfFood,
       success: function(response) {
         $('#restaurants-list-2').append(response);
       }
     })
      $.ajax({
        type: 'GET',
        url: '/deliveroo?food_type=' + typeOfFood,
        success: function(response) {
          $('#restaurants-list-2').append(response);
      }
     })
}







