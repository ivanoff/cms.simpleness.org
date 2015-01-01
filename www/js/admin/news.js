$(document).ready(function(){

    $('.delete').click(function () {
        save_text( '/admin/news/delete/'+$(this).attr('name'), {}, 'news was deleted'); 
        $(this).parent().parent().animate({opacity:0}, 700, function(){ $(this).css({display:"none"}); });
        if( $('#datepicker').attr('type') ) {
            setTimeout(function() {
                window.location.href='/news';
            }, 1000);
        }
        return false;
    });

    $(function() {
        $( "#datepicker" ).datepicker({
            onClose: function(date) {
                save_text( "/admin/news/"+$('.delete').attr('name')+"/update?date" , date );
                show_info( "date saved" );
              }
            , changeMonth: true
            , changeYear: true
            , dateFormat: 'yy-mm-dd'
        });
    });

    $('.closed_eye').click(function () {
        var id = $(this).attr('id');
        $('.closed_eye#'+id).hide();
        $('.opened_eye#'+id).show();
        save_text( '/admin/news/hide/1/'+id, {}, 'news was hided'); 
    });

    $('.opened_eye').click(function () {
        var id = $(this).attr('id');
        $('.opened_eye#'+id).hide();
        $('.closed_eye#'+id).show();
        save_text( '/admin/news/hide/0/'+id, {}, 'news was showed'); 
    });

});

