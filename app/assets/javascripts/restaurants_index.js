$(document).ready(function() {
  console.log('executed');
   if ($('#restaurants-list').length > 0) {
     var foodType1 = $('#food_type_1').val();
     var foodType2 = $('#food_type_2').val();
     $.ajax({
       type: 'GET',
       url: '/foodora?food_type=' + foodType1,
       success: function(response) {
         $('#restaurants-list').append(response);
       }
     })
     $.ajax({
      type: 'GET',
      url: '/deliveroo?food_type=' + foodType1,
      success: function(response) {
        $('#restaurants-list').append(response);
      }
     })
   }
 });
