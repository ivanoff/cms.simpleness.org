$(document).ready(function(){

    $(".admin_key").css({ opacity: 0.1 })
	    .mouseover( function(){ $(this).stop().animate({opacity:'1.0'},300); })
	    .mouseout ( function(){ $(this).stop().animate({opacity:'0.1'},300); });

    $.each(langValues, function(key, value) {
        if ( key ) {
            $('#languages')
                .append($("<option></option>")
                .attr("value", key )
                .css("background", "url('/images/flags/"+ key +".gif') no-repeat")
                .css("padding-left", "20px")
                .text(value)); 
        };
    });
    $("select option[value='"+(( typeof lang === 'undefined' )?  'en' : lang ) +"']").attr("selected","selected");
    $('#languages').change(function(){
        location = "//" + $(this).val() + "." + site + uri;
    });
});
