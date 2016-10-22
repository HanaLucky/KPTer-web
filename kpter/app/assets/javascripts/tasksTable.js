$(function() {
    $("#open-btn").click(function() {
        $(this).removeClass('btn-default').addClass('btn-primary');
        $("#close-btn").removeClass('btn-primary').addClass('btn-default');
    });
    $("#close-btn").click(function() {
        $(this).removeClass('btn-default').addClass('btn-primary');
    $("#open-btn").removeClass('btn-primary').addClass('btn-default');
    });
    // data-table setting
    setDataTables('dataTables-tasks');
});
