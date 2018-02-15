var chartTopOfAsignee = function (data) {
  chartDoughnut('topOfAsignee', 'Are your tasks well-balanced?', data.labels, data.data);
}

$(function() {
  settingDialog("dialog-button-leave", "dialog-button-leave");
  settingDialog("dialog-button-delete", "dialog-button-delete");
  settingDialog("dialog-button-edit", "dialog-button-edit");
  settingDialog("dialog-button-member", "dialog-button-member");
  settingDialog("dialog-button-new-board", "dialog-button-new-board");
  tableTrClickable("board-table");
});
