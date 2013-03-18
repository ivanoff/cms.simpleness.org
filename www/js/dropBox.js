$(document).ready(function() {
    
    var dropZone = $('.dropZone');
    var default_text = dropZone.html();

    if (typeof(window.FileReader) == 'undefined') {
//        dropZone.text('Не поддерживается браузером!');
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
        dropZone.html('Загрузка ' + file.name + " <img src='/images/btn_loading.gif'>");
	var fd = new FormData();
	fd.append("Filedata", file);
	fd.append("_SESSION_ID", session);
	var xhr = new XMLHttpRequest();
        xhr.open('POST', '/admin/gallery/upload/'+gallery_key, false);
        xhr.upload.addEventListener('progress', uploadProgress, false);
        xhr.onreadystatechange = stateChange;
	xhr.send(fd);

	if (xhr.status==200) {
	    $(".gallery ul").append(xhr.responseXML.getElementsByTagName("result")[0].firstChild.nodeValue);
	    $(function() { $('.gallery a').lightBox(); });
	}

});

    };

});
    

    function uploadProgress(event) {
        var percent = parseInt(event.loaded / event.total * 100);
        dropZone.text('Загрузка: ' + percent + '%');
    }
    
    function stateChange(event) {
        if (event.target.readyState == 4) {
            if (event.target.status == 200) {
                dropZone.text('Загрузка успешно завершена!');
            } else {
                dropZone.text('Произошла ошибка!');
                dropZone.addClass('error');
            }
    	    dropZone.fadeTo("slow", 0.33).fadeTo("slow", 1);
    	    dropZone.removeClass('drop');
    	    dropZone.html(default_text);
        }
    }
    
});