$(function() {

  // カードを作成
  var button = $('.btn');
  button.click(function(){
    console.log('createCard');
    $boardWrap = $('#boardWrap');
    $boardWrap.append('<div class="cardBox rounded ' + $(this).data('type').toString() + '" data-id=""></div>')

    $('.cardBox').draggable();
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
