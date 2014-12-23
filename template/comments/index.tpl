<html>
<head></head>
<link rel="stylesheet" href="/css/comments.css" />
<body>

<script>
$(function () {
    var msie6 = $.browser == 'msie' && $.browser.version < 7;
    if (!msie6) {
        $(window).scroll(function (event) {
            var new_y = $( "#main" ).position().top - $(document).scrollTop() - 20;
            if( 0 > new_y ) { new_y = 0; }
            $('#comment').css( "top", new_y );
        });
    }
});

function get_dim() {
    width_window = $( window ).width();
    width_main   = $('#main').width();
    width_border = Math.floor( (width_window - width_main)/2 );
    width_comment = $('#comment').width();
};

function comment_change_view( show ) {
    comment_show = show;
    if( show == 1 ) { 
        $('#comment').animate({ marginLeft: 0 } , 500);
    } else {
        $('#comment').animate({ marginLeft: width_border - 50 } , 500);
    }
    $.post( "/comments/show/"+show, "_SESSION_ID=[% session('_SESSION_ID') %]" );
};


$( document ).ready(function() {

    get_dim();

    var new_y = $( "#main" ).position().top - $(document).scrollTop() - 20;
    if( 0 > new_y ) { new_y = 0; }
    $('#comment').css( "top", new_y );

    comment_change_view( [% showcomm %] );

    $('#commentWrapper').css( "left", width_border + width_main ).css( "width", width_border );
    $('.commentWrapperf').css( "left", width_border + width_main );

    $('.commentWrapperf').each(function(){
        $(this).css( "top", Math.floor($('#main').height() * parseInt( $(this).attr('id'), 10 )/1000000 ) + $( "#main" ).position().top );
    });

    $('input[type=radio][name=comment_type]').change(function() {
        if( this.value == 'z' ) {
            $('#comment_name').html('Закладка');
            $('#comment_visible').hide();
        } else {
            $('#comment_name').html('Комментарий');
            $('#comment_visible').show();
        }
    });

    $('#comment_hide').click(function(e) {
        get_dim();
        comment_change_view( ( comment_show )? 0 : 1 );
    });

    $('#comment_show').click(function(e) {
        get_dim();
        if( !comment_show ) {
            comment_change_view( 1 );
        } else {
            $('#comment_value').focus();
            comment_ml = $('#comment').css('margin-left');
            if ( comment_show && width_comment > width_border && ( comment_ml == '0px' || margin-left == '0' ) ) {
                $('#comment').animate({ marginLeft: - width_comment + width_border } , 500);
            }
        }
    });

    $('.formrow').on('click', function() {
        get_dim();
        comment_ml = $('#comment').css('margin-left');
        if ( comment_show && width_comment > width_border && ( comment_ml == '0px' || margin-left == '0' ) ) {
            $('#comment').animate({ marginLeft: - width_comment + width_border } , 500);
        }
    });

    $('#comment').mouseleave(function() {
        if( comment_show && !$('#comment_value').is(":focus") ) {
            $('#comment').animate({ marginLeft: "0"} , 500);
        }
    });

    $('#main').click(function(e){ 
        position = $( "#main" ).position();
        y = e.pageY - $( "#main" ).position().top;
//       alert( y + ' of ' + $('#main').height() + ' is ' + ( y/$('#main').height()*100 ) +'%' );
        $('#comment').css( "top", e.pageY - $(document).scrollTop() - 20 );
        $('#comment_hide').attr('src','/images/arrow-right.gif');
//        if( !comment_show ) {
//            comment_change_view( 1 );
//        }
    });

    $('#comment_add').click(function() {
        var what_hash = {};
        what_hash["type"] = ( $('input[name=comment_type]:checked', '#comment_form').val() == 'k' )? '1' : '2';
        what_hash["text"] = $('#comment_value').attr('value');
        what_hash["position"] = ( $( '#comment' ).position().top - $( "#main" ).position().top + 20 ) / $( '#main' ).height();
        what_hash["private"] = ( $('input[name=comment_visible]:checked', '#comment_form').val() == 'on')? '1' : '0';
        $.post( '/comments/add', what_hash );
        alert('good');
    });

});

</script>

[% IF showcomm >= 0 %]
    <div id="commentWrapper">
      <div id="comment">
        <form id="comment_form">
        <img id="comment_show" src="/images/arrow-left.gif" width="19" height="15">
        <img id="comment_hide" src="/images/arrow-right.gif" width="19" height="15">
        <p class="formrow"><label for="comment_value" id="comment_name">Комментарий</label>
            <input type="text" class="text" id="comment_value" name="comment" value="">
            <br>
            <input type="radio" name="comment_type" value="k" checked>ком.
            <input type="radio" name="comment_type" value="z">закл.
            &nbsp; 
            <span id="comment_visible"><input type="checkbox" name="comment_visible" checked>невидимый</span>
        </p>
        <p><input type="button" id="comment_add" value="Сохранить"></p>
        </form>
      </div>
    </div>
[% END %]

    <div id="comments_div_config">
    </div>

[% right %]

</body></html>
