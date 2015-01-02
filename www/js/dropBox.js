$(document).ready(function() {
    
    var dropZone = $('.dropZone');
    var default_text = dropZone.html();

    if (typeof(window.FileReader) == 'undefined') {
//        dropZone.text('Do not support by browser!');
        dropZone.addClass('error');
    }

$.each( dropZone , function(j,z) {    

    dropZone[j].ondragover = function() {
        dropZone.addClass('hover');
        return false;
    };
    dropZone[j].ondragleave = function() {
        dropZone.removeClass('hover');
        return false;
    };

    dropZone[j].ondrop = function(event) {
        event.preventDefault();
        dropZone.removeClass('hover');
        dropZone.addClass('drop');
        
$.each( event.dataTransfer.files , function(i, file) {
        dropZone.html('Uploading ' + file.name + " <img src='/images/btn_loading.gif' style='width:16px;height:16px' border='0'>");
	var fd = new FormData();
	fd.append("Filedata", file);
	fd.append("_SESSION_ID", session);
	var xhr = new XMLHttpRequest();
        xhr.open('POST', '/admin/gallery/upload/'+gallery_key, false);
        xhr.upload.addEventListener('progress', uploadProgress, false);
        xhr.onreadystatechange = stateChange;
	xhr.send(fd);

	if (xhr.status==200) {
            $(".gallery ul").append('<li>'+xhr.responseXML.getElementsByTagName("result")[0].firstChild.nodeValue+'</li>');
            $(".gallery ul").append( $(".gallery ul .last_li") );
            $(function() { $('.gallery a').lightBox(); });
            $('.delete').click( onDelete );
	}

});

    };

});
    

    function uploadProgress(event) {
        var percent = parseInt(event.loaded / event.total * 100);
        dropZone.text('Upload: ' + percent + '%');
    }
    
    function stateChange(event) {
        if (event.target.readyState == 4) {
            if (event.target.status == 200) {
                dropZone.text('Uploud was succesfull! :)');
            } else {
                dropZone.text('There was an error while uploading!');
                dropZone.addClass('error');
            }
    	    dropZone.fadeTo("slow", 0.33).fadeTo("slow", 1);
    	    dropZone.removeClass('drop');
    	    dropZone.html(default_text);
        }
    }
    
});