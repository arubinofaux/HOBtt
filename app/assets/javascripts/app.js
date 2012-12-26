jQuery(document).ready(function() {
    $(".alert").alert();

    $("input[id=file]").change(function() {
        $("#file_path").val($(this)[0].files[0].name);
    });

    $("#fake_file_button").on("click", function(e) {
		e.preventDefault();
        $('input[id=file]').click();
    });

    $("#search_field").bind("keyup", function() {
        var form = $("#search"),
            url = "/live_search";
        var formData = form.serialize();

        $.get(url, formData, function(results) {
            $("#torrents_table tbody").html(results);
        });
    });

    $(".sortable").on("click", function(e) {
        var sortOrder, index = $("#torrents_table thead tr th").index($(this));

        $(".sortable i").removeClass("icon-chevron-up icon-chevron-down icon-white");

        if($(this).hasClass("sorted-desc")) {
            $(this).removeClass("sorted-desc");
            $("i", this).addClass("icon-chevron-up icon-white");
            sortOrder = 1;
        } else {
            $(this).addClass("sorted-desc");
            $("i", this).addClass("icon-chevron-down icon-white");
            sortOrder = -1;
        }
        sortTable(sortOrder, index);
    });
});

var sortTable = function(order, index) {
    var rows = $("#torrents_table tbody tr").get();

    $.each(rows, function(i, row) {
        row.sortKey = $(row).children("td").eq(index).text();
    });

    rows.sort(function(a, b) {  
        return (a.sortKey < b.sortKey) ? -order : order; 
    });

    $.each(rows, function(i, row) {
        $("#torrents_table tbody").append(row);
        row.sortKey = null;
    });
}