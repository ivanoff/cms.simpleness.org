    var myNicEditor;

    var save_text = function ( where, what ) {
//	if ( what == "click to edit" ) return 0;
	if( where.indexOf(":") ) {
	    var a = where.split(":");
	    module = a[0];
	    where  = a[1];
	} else {
	    module = 'content';
	}
    	$(window).unbind("beforeunload");
	var fd = new FormData();
	fd.append("page", where);
	fd.append("body", what);
	fd.append("lang", lang);
	fd.append("_SESSION_ID", session);
	var xhr = new XMLHttpRequest();
	xhr.open("POST", "/admin/"+ module +"/update");
	xhr.send(fd);
    };

    $('.editable').live('keypress', function() { 
	$(window).bind("beforeunload", function() { return "saving..."; }); 
    });
    bkLib.onDomLoaded(function() {
	var current_text = '';
        myNicEditor = new nicEditor({
		fullPanel : true, 
		onSave : function(content, id, instance) {
		    save_text( id, content );
		    current_text = content;
		    },
		pageheader : title, 
		page : page, 
		lang : lang, 
		session : session
  	    });

        myNicEditor.setPanel('myNicPanel');
	$(".editable").each(function(){ 
	    if ( $(this).text().replace(/(\n|\r|\s)+$/, '') == "" ) $(this).html("<font color='#AAA'><small>click to edit</small></font>");
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