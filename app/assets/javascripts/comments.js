$(function () {
    $('body').on('click', 'button.cancel-comment', function (e) {
        e.preventDefault();
        $(this).parents().eq(2).find('.add-comment-link').show();
        $(this).parents().eq(1).empty();
    })
});