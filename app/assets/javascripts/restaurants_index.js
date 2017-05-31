$(function() {
  if ($('#restaurants-list').length > 0) {
    $.ajax({
      type: 'GET',
      url: '/foodora,
      success: function(response) {
        $('#restaurants-list').append(response);
      }
    })
  }
});


// $(function() {
//   if ($('#restaurants-list').length > 0) {
//     var foodType $('#food_type').val();
//     $.ajax({
//       type: 'GET',
//       url: '/foodora?food_type=' + foodType,
//       success: function(response) {
//         $('#restaurants-list').append(response);
//       }
//     })
//   }
// });
