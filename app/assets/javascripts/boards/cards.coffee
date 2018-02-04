# カード作成ボタンの設定
button = $('.tool-bar-button')
button.click((-> App.board.initialize_buttons($(this))))

# カードの初期化
App.board.initialize_cards()