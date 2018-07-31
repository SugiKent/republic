// Ajax検索用
$(document).on('change', '#faculty_id', function() {
  $.ajax({
    type: 'GET',
    url: '/lesson/departments_select',
    data: {
      faculty_id: $(this).val()
    }
  }).done(function(departmentdata) {
    $('.js-departments_select').html(departmentdata);
  });
});
