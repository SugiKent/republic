$(document).on('turbolinks:load', function(){

  var menuOpened = false,
      menuType = '';

  /*
  * 以下spメニューの挙動
  */
  $('.Header__menu-btn[data-type="account"]').on('click',function(){
    clickMenuBtn(this);
    scrollTop();
  });

  $('.Header__menu-btn[data-type="search"], .Header__menu-btn[data-type="bell"]').on('click',function(){
    var type = $(this).data('type');

    if (type == 'bell') {
      updateUserReadedAt();
    }

    if ( $('.Header__menu-btn--active').data('type') == type ) {
      closeAllSpMenus();
      return false
    }

    toggleHeaderModal(this);
  });

  $('.js-Header__close').on('click',function(){
    closeAllSpMenus();
  });

  $(document).on('click', function(e) {
    if (!$(e.target).closest('.Header__menu-btn').length) {
      if (!$(e.target).closest('.js-Header__modal').length) {
        closeAllSpMenus();
      }
    }
  });

  /*
  * 以下pcのヘッダー挙動
  */
  $('.Header__pc-icon').on('click',function(){
    $('.Header__pc-icon').children('a').children('i').css('color', '#888');

    var type = $(this).data('type'),
        target = $('.Header__pc-icon-menu--'+type);

    if (type == 'bell') {
      updateUserReadedAt();
    }

    // メニューがopenの状態で、開いてるメニューのアイコンをクリックしたら全てのメニューを閉じる
    if (menuOpened && type == menuType) {
      closeAllMenus();
      menuType = '';
      return false
    }

    $('.Header__pc-icon-menu').not(target).hide();
    showMenuBtn(type);
    menuOpened = true;
    menuType = type;
  });

  $(document).on('click', function(e) {
    if (!$(e.target).closest('.Header__pc-icon').length) {
      if (!$(e.target).closest('.Header__toggleMenus').length) {
        closeAllMenus();
        menuType = '';
        menuOpened = false;
      }
    }
  });

  // 通知欄にマウスがある場合、js-fixedをbodyに追加してスクロールできないようにする
  $('.Header__pc-icon-menu--bell').hover(function() {
    $('body').toggleClass('js-fixed');
  });

});

// spのハンバーガーメニュークリック時の全体の挙動制御
function clickMenuBtn(elem) {
  closeAllSpMenus();

  $('.Header__menu').toggleClass('Header__menu--active');
  $('.container').toggleClass('slided');
  $('.Footer').toggleClass('slided');
  $('.Header').toggleClass('Header--fixed');

  animateMenuBtn(elem);
}

// userテーブルのreaded_atを更新するAjax
function updateUserReadedAt() {
  $.ajax({
    type: 'GET',
    url: '/user_notifications/update_readed_at',
    dataType: "html"
  });
}

// sp
// メニューの表示/非表示を切り替える
function toggleHeaderModal(elem) {
  closeAllSpMenus();
  var type = $(elem).data('type');
  $('.js-Header__modal[data-type="'+type+'"]').animate({
    height: 'toggle'
  });
  $(elem).toggleClass('Header__menu-btn--active');
}

// sp
// 全てのメニューを閉じる
function closeAllSpMenus() {
  $('.js-Header__modal').slideUp();
  $('.Header__menu-btn').removeClass('Header__menu-btn--active')
}

// sp
// ハンバーガーボタンの挙動
function animateMenuBtn(elem) {
  $(elem).toggleClass('Header__menu-btn--active');
  $('.Header__menu-btn span:first-child').toggleClass('Header__menu-btn--top');
  $('.Header__menu-btn span:eq(1)').toggleClass('Header__menu-btn--middle');
  $('.Header__menu-btn span:last-child').toggleClass('Header__menu-btn--bottom');
}

// sp
// メニューを閉じた後に、トップにスクロールして表示する様に
function scrollTop() {
  $(window).scrollTop(0);
}

// pc
// メニューボタン押下時の挙動制御
function showMenuBtn(type) {
  // 指定のtypeのメニューを表示
  $('.Header__pc-icon-menu--'+type).show();
  // 指定のtypeのメニューアイコンをpurpleに
  $('.Header__pc-icon[data-type='+type+']').children('a').children('i').css('color', '#c71585');
}

// pc
// 全てのメニューを閉じる
function closeAllMenus() {
  $('.Header__pc-icon-menu').hide();
  $('.Header__pc-icon').children('a').children('i').css('color', '#888');
  menuType = '';
  menuOpened = false;
}
