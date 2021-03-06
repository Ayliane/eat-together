
if ($('.animation').length > 0) {
function dataWord () {

  $("[data-words]").attr("data-words", function(i, d){
    var $self  = $(this),
        $words = d.split("|"),
        tot    = $words.length,
        c      = 0;

    // CREATE SPANS INSIDE SPAN
    for(var i=0; i<tot; i++) $self.append($('<span/>',{text:$words[i]}));

    // COLLECT WORDS AND HIDE
    $words = $self.find("span").hide();

    // ANIMATE AND LOOP
    (function loop(){
      $self.animate({ width: $words.eq( c ).width() });
      $words.stop().fadeOut().eq(c).fadeIn().delay(2000).show(0, loop);
      c = ++c % tot;
    }());

  });

}

// dataWord(); // If you don't use external fonts use this on DOM ready; otherwise use:
$(window).on("load", dataWord);


}

$(document).ready(function() {
  if ($('.pages.home').length > 0) {
    $('[name="food_type_1"]').selectize({
      openOnFocus: false,
      placeholder: 'Your cuisine...'
    });

    $('[name="food_type_2"]').selectize({
      openOnFocus: false,
      placeholder: 'His/Her cuisine...'
    });
  }
});






