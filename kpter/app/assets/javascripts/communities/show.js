$(function() {
  // read more. https://vitalets.github.io/x-editable/index.html
  $('#community-name').editable({
    tpl: '<input type="text" maxlength=32 style="width:450px;">',
    success: function(response, newValue) {
        // 左サイドナビのコミュニティ名を書き換える
        $('#navi-communities li .active').html('<i class="fa fa-comment fa-fw"></i>' + escapeHTML(newValue));
    },
    error: function(response, newValue) {
      var res = JSON.parse(response.responseText);
      // XXX: 不正に入力された場合のエラー。ポップアップではなく、メッセージ表示したい。現状はmaxlengthで入力文字数制御。
      alert(res.message);
    }
  });

  /**
   * コミュニティ招待のモーダル表示、非表示にする
   */
  $('.end_action_invite').click(function() {
    $('body').append('<div class="modal-overlay"></div>');
    $('.modal-overlay').fadeIn(200);
    var modal = '.modal_invite_other';
    modalResize();
    $(modal).fadeIn(200);

    $('.modal-overlay, .modal-close').off().click(function(){
      $(modal).fadeOut(200);
      $('.modal-overlay').fadeOut(200, function(){
          // オーバーレイを削除
        $('.modal-overlay').remove();
      });
    });

    $(window).on('resize', function(){
      modalResize();
    });

    function modalResize(){
      // ウィンドウの横幅、高さを取得
      var w = $(window).width();
      var h = $(window).height();
      // モーダルコンテンツの表示位置を取得
      var x = (w - $(modal).outerWidth(true)) / 2;
      var y = (h - $(modal).outerHeight(true)) / 2;
      // モーダルコンテンツの表示位置を設定
      $(modal).css({'left': x + 'px','top': y + 'px'});
    }
  });
});
