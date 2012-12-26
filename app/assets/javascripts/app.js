jQuery(document).ready(function() {
    $(".alert").alert();

    $("input[id=file]").change(function() {
        $("#file_path").val($(this)[0].files[0].name);
    });

    $("#fake_file_button").on("click", function(e) {
		e.preventDefault();
        $('input[id=file]').click();
    });

    $("#search_form").bind("keyup", function() {
        var form = $("#search"),
            url = "/live_search";
        var formData = form.serialize();

        $.get(url, formData, function(results) {
            $("#torrents_table tbody").html(results);
        });
    });
});