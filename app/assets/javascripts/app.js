jQuery(document).ready(function() {
    $(".alert").alert();

    $("input[id=file]").change(function() {
        $("#file_path").val($(this).val());
    });

    $("#fake_file_button").on("click", function() {
        $('input[id=file]').click();
    });
});