var setTasksCount = function (data) {
  document.querySelector("#open-task-count").innerHTML = data.open_task_count;
}
$(function() {
  tableTdClickableAjax("t_cards-table-data", "edit_task_modal_event");
});
