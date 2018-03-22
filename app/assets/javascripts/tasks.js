$(document).ready(function() {
  $('body').on('click', '.task-checkbox-form input[type=checkbox]', function() {
    $(this).parents('form').find('input[name=commit]').click();
  });

  $('body').on('click', '.expand-task', function(e) {
    e.preventDefault();

    var $item = $(this).parents('.item');

    if ($item.is('.show')) {
      $item.removeClass('show');
      $(this).text('+');
    }
    else {
      $item.addClass('show');
      $(this).text('-');
    }

  });
});
