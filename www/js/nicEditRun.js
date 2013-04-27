    var myNicEditor, myNicEditor_plain;
    var content_current_page = new Object();
    var cid;
    var saved_onreload=0;

    var is_silent = function ( what ) {
        return ( $("div[id*='"+what+"'].silent").attr('id') );
    }

    var save_text = function ( where, what, info ) {

    	$(window).unbind("focusout");

        var what_hash = {};
	if( where.indexOf("?") == -1 ) {
            what_hash = what;
        } else {
            if ( is_silent(where) && !info ) return false;
	    var a = where.split("?");
            if( content_current_page[where] == what ) return false;
            content_current_page[where] = what;
	    where = ( a[0]!='' )? a[0] : '/admin/content/update';
	    what_hash = { 'page' : a[1], 'body' : what };
        }

        $.each(what_hash, function(key, value) {
            if ( is_silent( where+'?'+key ) && !info ) return false;
            if ( value == "<br>" ) value='';
            what_hash[key] = value;
        });
        what_hash["_SESSION_ID"] = session;
        what_hash["lang"] = lang;
        $.post( where, what_hash );
/*
	var fd = new FormData();
	fd.append("_SESSION_ID", session);
	fd.append("lang", lang);
        $.each(what_hash, function(key, value) {
            if ( is_silent( where+'?'+key ) && !info ) return false;
            if ( value == "<br>" ) value='';
            fd.append(key, value);
        });
	var xhr = new XMLHttpRequest();
	xhr.open("POST", where);
	xhr.send(fd);
*/
        show_info( (info)? info : "content saved" );
        
        return true;

    };

    $('.editable').live('focusin', function() { 
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

    bkLib.onDomLoaded(function() {

	var current_text = '';
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