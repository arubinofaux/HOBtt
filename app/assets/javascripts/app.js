jQuery(document).ready(function() {
    $(".alert").alert();

    $("input[id=file]").change(function() {
        $("#file_path").val($(this)[0].files[0].name);
    });

    $("#fake_file_button").on("click", function(e) {
		e.preventDefault();
        $('input[id=file]').click();
    });
});