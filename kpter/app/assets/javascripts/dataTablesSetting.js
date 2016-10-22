function setDataTables(tableId) {
  $('#' + tableId).DataTable({
    // レスポンシブ表示
    responsive: true,
    // 件数切替機能 無効
    lengthChange: false,
    // 検索機能 無効
    searching: false,
    // 情報表示 無効
    info: false,
    // ページング機能 無効
    paging: false,
    // 並び順機能 無効
    ordering: false
  });
}
