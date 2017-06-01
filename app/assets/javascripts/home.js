// $(document).ready(function() {

// setInterval(function() {
//   var $current = $('.show');
//   var $next = $current.next();

//     if ($current === ul.lastChild) {
//    $current = ul.firstChild
//    $current.addClass('hidden').removeClass("show");
//    $next.addClass('show').removeClass("hidden");
//    } else {
//    $current.addClass('hidden').removeClass("show");
//    $next.addClass('show').removeClass("hidden");
//    }

// },5000);
//  });


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










