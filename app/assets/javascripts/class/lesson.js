$(document).on('turbolinks:load resize load', function(){
  var lessonModule = '.js-LessonModule__item',
      lessonModuleHeight = 0,
      windowWidth = 0;

// 初回ログイン時のモーダルをAjaxで取得
  function showFirstModal(){
    if ( $('.fl p').text() == 'fl' ){
      $.ajax({
        type: 'GET',
        url: '/lesson/first_login',
      }).done(function(howto) {
        $('#howto__module').html(howto);
        $('.js-FinalLogin__btn').on('click', function(){
          var secNum = parseInt($(this).parents().parents().parents().attr('id'));
          if ($(this).text() == 'つぎへ>>') {
            var secIdNum = secNum + 1;
          } else if ($(this).text() == 'さぁはじめよう！') {
            $('#howto__module').hide('slow');
          } else {
            var secIdNum = secNum - 1;
          }
          $('#'+secNum).toggleClass('FirstLogin__section--hide');
          $('#'+secNum).toggleClass('FirstLogin__section--show');
          $('#'+secIdNum).toggleClass('FirstLogin__section--hide');
          $('#'+secIdNum).toggleClass('FirstLogin__section--show');
        });
      });
    }
  }


  function setWindowWidth(){
    windowWidth = $(window).width();
  }
  // 授業モジュールの最高値を獲得
  function checkLessonModuleHeight(elem){
    if (lessonModuleHeight < $(elem).height()) {
      lessonModuleHeight = $(elem).height();
    }
  }
  // 獲得した最高値を全授業モジュールに反映
  function setLessonModuleHeight(colNum){
    var count = 1
    $(lessonModule).each(function(){
      if (count == colNum) {
        checkLessonModuleHeight(this);
        var target = $(this);
        for (var i = 0; i < colNum; i++) {
          target.height(lessonModuleHeight);
          target = target.prev();
        }
        lessonModuleHeight = 0;
        count = 1;
      } else {
        checkLessonModuleHeight(this);
        count ++;
      }
    });
  }

  // 実行
  $(document).on('turbolinks:load resize load scroll', function(){
    setWindowWidth();
    if (windowWidth > 991 ) {
      setLessonModuleHeight(3);
    } else if (windowWidth > 767) {
      setLessonModuleHeight(2);
    }
  });

  showFirstModal();
  showToolTip();

  // lesson#showでレビュー新規作成後のモーダルを表示する
  $(document).on('turbolinks:load load ready', function(){
    $('#resultCreatedModal').modal();
  });

});

function showToolTip() {
  var target = '.js-LessonModule__tooltip:first';
  setTimeout(function(){
    $(target).tooltip('show');
  }, 3000);
  setTimeout(function(){
    $(target).tooltip('hide');
  }, 10000);
  $('*').on('turbolinks:click',function(){
    $(target).tooltip('hide');
  });
}
