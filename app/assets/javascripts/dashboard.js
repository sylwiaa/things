$(document).ready(function() {

  $('.klasa').on('click', function(event) {
    event.preventDefault();

    $(this).toggleClass('bold');

    if ($('h1').is('.red')) {
      $('h1').removeClass('red');
    } else {
      $('h1').addClass('red');
    }
  });


  $('#increment').on('click', function() {
    var countString = $('#counter').text();
    var count = parseInt(countString);
    $('#counter').text(count + 1);
  })

  // $('#increment').on('mouseover', function() {
  //   count = count + 2; // += 2
  //   $('#counter').text(count);
  // })

  // $('#increment').on('mouseout', function() {
  //   count = count - 1;
  //   $('#counter').text(count);
  // })

});
