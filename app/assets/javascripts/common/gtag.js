$(document).on('turbolinks:load', function(){
  if ( window.gtag != undefined ) {
    var current_user = $('.js-GA__user').data('user');
    gtag('config', 'UA-90999999-9', {
      'custom_map': {'dimension1': 'user_login'},
      'user_login': String(current_user),
      'optimize_id': 'GTM-XXXX9XX',
      'page_path': window.location.pathname
    });
  }
});

// Footerにログイン状態を隠しタグに記載
