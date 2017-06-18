$(function() {

  $('.cardBox').draggable();
  
  // カードを作成
  var button = $('.btn');
  button.click(function(){
    $boardWrap = $('#boardWrap');
    var board_id = $('[name=board_id]').val();
    var type = $(this).data('type').toString();
    var title = $(this).data('title');
    var off = $(this).offset()

    if (type === 'keep' || type === 'problem') {
      App.board.create_kpcard(type, title, board_id, off.left, off.top)
    } else if (type === 'try') {
      App.board.create_tcard(title, board_id, off.left, off.top)
    }
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
