$(document).ready(function(){

    if( typeof cte_text == 'undefined' ){
        cte_text = '<font color="#AAA"><small>[% t('click to edit') %]</small></font>';
    }

    $(".editable").each(function(){ 
        if ( $(this).html().replace(/(\n|\r|\s)+$/, '') == "" ) {
            $(this).html( cte_text );
            $(this).live('click', function () {
                if( $(this).html() == cte_text ){
                    $(this).html("<br>");
                };
	    });
        }
    });

    $("#admin_key").css({ opacity: 0.1 })
	    .mouseover( function(){ $(this).stop().animate({opacity:'1.0'},300); })
	    .mouseout ( function(){ $(this).stop().animate({opacity:'0.1'},300); });

        show_info('');

});

function show_info( t ) {
    if ( t ) {
        $('#myNicPanel_info').text( t );
        $("#myNicPanel_info").show('blind', {}, 500);
        setTimeout(function() {
            $("#myNicPanel_info").hide('blind', {}, 500)
        }, 3000);
    } else {
        $("#myNicPanel_info").hide();
    }
};

