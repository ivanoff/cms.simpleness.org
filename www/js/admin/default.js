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


    var myNicEditor, myNicEditor_plain;
    var content_current_page = new Object();
    var cid;
    var saved_onreload=0;

    var current_text = '';

    var is_dont_save = function ( what ) {
        return ( $("div[id*='"+what+"'].dont_save").attr('id') );
    }

    var save_text = function ( where, what, info ) {

        $(window).unbind("focusout");

        var what_hash = {};
        if( typeof what === 'object' && Object.keys(what) instanceof Array ) {
            what_hash = what;
        } else if( where.indexOf("?") == -1 ) {
            what_hash["body"] = what;
        } else {
            if ( is_dont_save(where) && !info ) return false;
            var a = where.split("?");
            if( content_current_page[where] == what ) return false;
            content_current_page[where] = what;
            where = ( a[0]!='' )? a[0] : '/admin/content/update';
            what_hash = { 'page' : a[1], 'body' : what };
        }

        $.each(what_hash, function(key, value) {
            if ( is_dont_save( where+'?'+key ) && !info ) return false;
            if ( value == "<br>" ) value='';
            what_hash[key] = value;
        });
        what_hash["_SESSION_ID"] = session;
        what_hash["lang"] = lang;
        if ( !what_hash["page"] ) what_hash["page"] = uri;
        $.post( where, what_hash );

        show_info( (info)? info : "content saved" );
        
        return true;

    };


$(document).ready(function(){

    show_info('');

    if( typeof cte_text == 'undefined' ){
        cte_text = '<font color="#AAA"><small>click to edit</small></font>';
    }

    $(".editable").each(function(){ 
        if ( $(this).html().replace(/(\n|\r|\s)+$/, '') == "" ) {
            $(this).html( cte_text );
            $(this).on('click', function () {
                if( $(this).html() == cte_text ){
                    $(this).html("<br>");
                };
	    });
        }
    });


    $('.editable').on('focusin', function() { 
	cid = $(this).attr('id');
        $(this).bind("focusout", function() { 
            if ( saved_onreload != 1 ) {
                saved_onreload = 1;
	        save_text( $(this).attr('id'), $(this).html() );
	    }
        });
        $(this).keydown(function(e) {
            if ( (e.ctrlKey && e.which == 82) || e.which == 116) {
                if ( saved_onreload != 1 ) {
                    saved_onreload = 1;
	            save_text( $(this).attr('id'), $(this).html() );
	            alert('content has been saved');
	        }
            }
        });
    });


    myNicEditor = new nicEditor({
	fullPanel : true, 
	onSave : function(content, id, instance) {
	    save_text( id, content );
	    current_text = content;
	    },
	lang : lang, 
	pageheader : title, 
	page : page, 
	session : session,
	uri : uri
    });

    myNicEditor.setPanel('myNicPanel');

    $(".editable").each(function(){ 
        myNicEditor.addInstance(this.id); 
    });

    myNicEditor.addEvent('focus', function() {
        current_text = this.selectedInstance.getContent();
    });

    myNicEditor.addEvent('blur', function() {
        if( this.selectedInstance && current_text != this.selectedInstance.getContent() ) {
            save_text(this.selectedInstance.elm.id, this.selectedInstance.getContent());
	}
    });


});



