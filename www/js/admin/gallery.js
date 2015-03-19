$(document).ready(function(){

        function rotate_image ( what, un ) {
            rotate = un? 'unrotate' : 'rotate';
            id   = what.attr('id');
            save_text( '/admin/images/'+ rotate +'/'+what.attr('name'), {}, 'please, wait...' ); 
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

        $('.delete').click(function () {
            save_text( '/admin/gallery/delete/g'+$(this).attr('name'), {}, 'gallery was deleted'); 
	    $(this).parent().parent().parent().animate({opacity:0}, 700, function(){ $(this).css({display:"none"}); });
	    return false;
        });

        $('.delete_image').click(function () {
            save_text( '/admin/gallery/delete/i'+$(this).attr('id'), {}, 'please, wait...' ); 
            save_text( '/admin/images/delete/'+$(this).attr('name'), {}, 'image was deleted' ); 
	    $(this).parent().parent().animate({opacity:0}, 700, function(){ $(this).css({display:"none"}); });
	    return false;
        });

	$( "#gallerys" ).sortable(
	    { opacity: 0.8, revert: true, 
		start: function(event, ui) { $('.gallery a').unbind(); }, 
		stop:  function(event, ui) { $('.gallery a').lightBox(); }, 
		update: function(event, ui) { 
		    var result = [];
		    $('#gallerys').each(function(){
			$(this).find('li').each(function(){
			    result.push ( $(this).find('a img').attr('id') );
			});
		    });
//		    alert (result.join());
                    save_text( '/admin/gallery/sort/'+result.join(), {}, 'image position saved'); 
		} 
	    });
	$( "#gallerys" ).disableSelection();

});

