$(document).on('turbolinks:load', function(){
  $('.Pdf__checkbox-block label').on('change', function(){
    watchPdfCheckbox(this);
  });

  function watchPdfCheckbox(elem) {
    var val = $('.Pdf__checkbox-block input:checked').map(function() {
      return $(this).val();
    }).get();
    var name = $('.Pdf__checkbox-block input:checked').map(function() {
      text = $(this).next().text() + "&nbsp;&nbsp;"
      return text
    }).get();
    setIds(val);
    setName(name);
  }

  function setIds(val) {
    $('#department_ids').val('[' + val + ']')
  }

  function setName(name) {
    $('.Pdf__selected-department').html('<div class="alert alert-warning">' + name + '</div>');
  }
});
