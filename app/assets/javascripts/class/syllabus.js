$(document).on('turbolinks:load', function(){
  $('.Syllabus__more--button').on('click',function(){
    moreButton(this);
  });

  function getTarget(elem) {
    return $(elem).attr('data-target');
  }

  function moreButton(elem) {
    var target = getTarget(elem);
    $('.'+target).animate({
      height: 'toggle',
      opacity: 1
    });
  }
});
