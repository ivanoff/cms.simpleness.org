$(document).ready(function(){
        $('.delete').click(function () {
            save_text( '/admin/gallery/delete/'+$(this).attr('name'), {}, 'gallery was deleted'); 
	    $(this).parent().parent().parent().animate({opacity:0}, 700, function(){ $(this).css({display:"none"}); });
	    return false;
        });

        $('.delete_image').click(function () {
            save_text( '/admin/gallery/delete/'+$(this).attr('name'), {}, 'image was deleted'); 
	    $(this).parent().parent().animate({opacity:0}, 700, function(){ $(this).css({display:"none"}); });
	    return false;
        });

        $('.rotate_image').click(function () {
            id = $(this).attr('name');
            save_text( '/admin/gallery/rotate/'+id, {}, 'please, wait...' ); 
            $("#"+id).animate( {opacity:0.5}, 500 );
            setTimeout(function() {
                show_info( "image was clockwised" );
                $("#"+id).attr( "src", $("#"+id).attr( "src" ) + '?' + Math.random() );
                $("#"+id).animate( {opacity:1}, 500 );
            }, 1500);
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

