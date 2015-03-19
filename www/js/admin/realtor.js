$(document).ready(function(){

        function rotate_image ( what, un ) {
            rotate = un? 'unrotate' : 'rotate';
            id     = what.attr('id');
            save_text( '/admin/images/' + rotate + '/' + what.attr('name'), {}, 'please, wait...' ); 
            $("#i"+id).animate( {opacity:0.5}, 500 );
            setTimeout(function() {
                show_info( "image was clockwised" );
                $("#i"+id).attr( "src", $("#i"+id).attr( "src" ) + '?t=' + Math.random() );
                $("#i"+id).animate( {opacity:1}, 500 );
            }, 1500);
            return false;
        }

        $('.rotate_image').click(   function () { rotate_image ( $(this), 0 ) } );
        $('.unrotate_image').click( function () { rotate_image ( $(this), 1 ) } );

});

