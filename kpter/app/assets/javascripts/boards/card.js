$(function() {

  $('.cardBox').draggable()

  // カードを作成
  var button = $('.btn');
  button.click(function(){
    $boardWrap = $('#boardWrap');
    var board_id = $('[name=board_id]').val();
    var type = $(this).data('type').toString();
    var title = ""
    var off = $(this).offset();

    if (type === 'keep' || type === 'problem') {
      App.board.create_kpcard(type, title, board_id, off.left, off.top)
    } else if (type === 'try') {
      App.board.create_tcard(title, board_id, off.left, off.top)
    }
  });

  // カード情報変更
  // 位置変更
  $( ".cardBox" ).on( "dragstop", function(event, ui ){
    var $this = $(this);
    var type = event.target.dataset.type;
    var id = $this.attr("id");
    var title = $this.text();
    var off = $this.offset();
    console.log(title)
    console.log(type);
    console.log(off);
    if (type === 'keep' || type === 'problem') {
      App.board.update_kpcard(id, type, title, off.left, off.top)
    } else if (type === 'try') {
      App.board.update_tcard(id, title, off.left, off.top)
    }
  });

  $('body').on('focus', '[contenteditable]', function() {
    var $this = $(this);
    $this.data('before', $this.html());
    console.log('focus');
    console.log($this);
    return $this;
  }).on('blur keyup paste input', '[contenteditable]', function() {
      var $this = $(this);
      if ($this.data('before') !== $this.html()) {
          $this.data('before', $this.html());
          $this.trigger('change');
      }
      console.log('blur keyup paste input');
      console.log($this);
      return $this;
  });

  // ゴミ箱へドロップ可能にする
  var trashCan = $('#trashCan');
  trashCan.droppable({
    tolerance: "intersect",
    drop: function(ev, ui) {
      // Draggable要素が上に乗ったときカードを削除
      ui.draggable.remove();
  }
  });
});
