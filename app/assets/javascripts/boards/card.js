$(function() {
  $('.cardBox').draggable();
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

  // ゴミ箱へドロップ可能にする
  var trashCan = $('#trashCan');
  trashCan.droppable({
    tolerance: "intersect",
    drop: function(event, ui) {
      //$("##{card_id}").data('type', type)
      var id = ui.draggable[0].id.split("_")[1];
      var type_id = ui.draggable[0].id;
      var type = ($("#" + type_id).data('type'));
      // Draggable要素が上に乗ったときカードを削除
      if (type === 'keep' || type === 'problem') {
        App.board.delete_kpcard(id);
        ui.draggable.remove();
      } else if (type === 'try') {
        App.board.delete_tcard(id);
        ui.draggable.remove();
      }
    }
  });
});
