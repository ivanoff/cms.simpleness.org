    var myNicEditor, myNicEditor_plain;
    var content_current_page = new Object();

    var save_text = function ( where, what, info ) {

//alert ($("div[id*='"+where+"'] > .silent").text());
    	$(window).unbind("focusout");
        if( content_current_page[where] == what ) return false;
        content_current_page[where] = what;

        if ( what == "<br>" ) what='';
	if( where.indexOf(":") ) {
	    var a = where.split(":");
	    module = a[0];
	    where  = a[1];
	} else {
	    module = 'content';
	}
	var fd = new FormData();
	fd.append("page", where);
	fd.append("body", what);
	fd.append("lang", lang);
	fd.append("_SESSION_ID", session);
	var xhr = new XMLHttpRequest();
	xhr.open("POST", "/admin/"+ module +"/update");
	xhr.send(fd);

        show_info( (info)? info : "content saved" );

    };

    $('.editable').live('focusin', function() { 
        $(this).bind("focusout", function() { 
	    save_text( $(this).attr('id'), $(this).html() );
        });
        $(this).keydown(function(e) {
            if ( (e.ctrlKey && e.which == 82) || e.which == 116) {
	        save_text( $(this).attr('id'), $(this).html() );
	        alert('content has been saved');
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