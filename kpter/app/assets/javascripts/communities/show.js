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
});
