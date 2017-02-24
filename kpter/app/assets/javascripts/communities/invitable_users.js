$(function() {
  // レコードクリックでチェックON/OFFできるようにする
  $('.invite-table tr').click(function(event) {
    if (event.target.type !== 'checkbox') {
      $(':checkbox', this).trigger('click');
    }
  });

  // ユーザー名絞り込みセッティング
  // see. http://listjs.com/
  var options = {
    valueNames: [ 'username' ],
  };
  var userList = new List('users', options);
});
