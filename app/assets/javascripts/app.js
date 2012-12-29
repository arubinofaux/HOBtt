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
        var sortOrder,
            sortType = $(this).attr("title"),
            index = $("#torrents_table thead tr th").index($(this));

        $(".sortable i").removeClass("icon-chevron-up icon-chevron-down icon-white");

        if($(this).hasClass("sorted-desc")) {
            $(this).removeClass("sorted-desc");
            $("i", this).addClass("icon-chevron-down icon-white");
            sortOrder = 1;
        } else {
            $(this).addClass("sorted-desc");
            $("i", this).addClass("icon-chevron-up icon-white");
            sortOrder = -1;
        }
        sortTable(sortType, sortOrder, index);
    });
});

var sortTable = function(sortType, order, index) {
    var rows = $("#torrents_table tbody tr").get();

    $.each(rows, function(i, row) {
        row.sortKey = $(row).children("td").eq(index).text();
        if(sortType == "files") {
            row.sortKey = parseInt(row.sortKey);
        }
    });

    if(sortType == "size") {
        rows.sort(function(a, b) {
            var x = a.sortKey.split(' '), // Inputs are eg. '365.4 KB'
                y = b.sortKey.split(' '), // Which would yield ["365.4", "KB"]
                abr = {'Bytes': 0, 'B': 0, 'KB': 1, 'MB': 2, 'GB': 3, 'TB': 4};

            if(abr[x[1]] > abr[y[1]]) { return order }
            else if(abr[x[1]] < abr[y[1]]) { return -order }
            else { return (parseFloat(x[0]) < parseFloat(y[0])) ? -order : order }
        });
    }
    else {
        rows.sort(function(a, b) {  
            return (a.sortKey < b.sortKey) ? -order : order;
        });
    }

    $.each(rows, function(i, row) {
        $("#torrents_table tbody").append(row);
        row.sortKey = null;
    });
}