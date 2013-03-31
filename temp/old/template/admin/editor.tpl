<script type="text/javascript">
    $(document).ready(function(){
	$('#editor[% source %]_div').hide();
	$('#ime[% source %]_div').click(function () {
	    $('#editor[% source %]_div').toggle();
	    $('#source[% source %]_div').toggle();
	    if ($('#ime[% source %]_div').attr("alt") == 'close') {
		$('#ime[% source %]_div').attr("src", "/images/btn_edit.gif").attr("alt", "edit");
	    } else {
		$('#ime[% source %]_div').attr("src", "/images/btn_delete.gif").attr("alt", "close");
	    }
	});
    });
</script>

<div style="position: relative; bottom: 0; left: 0.5em; z-index:10;"> 
	<img align="right" id="ime[% source %]_div" src="/images/btn_edit.gif" alt="edit">
</div>
	<div id="editor[% source %]_div">
	    <form action="/admin/content_modify" method="post">
		<p>
			<textarea class="ckeditor__" cols="80" id="editor[% (source)? source : 1 %]" name="body" rows="10">[% (source)? sources.item(source).content_body : content %]</textarea>
		</p>
		<p>
			header: <input name="pageheader" value="[% (source)? source : title %]" />
			<input type="checkbox" name="no_lang_cache" value="1">don't use language cache
		</p>
		<p>
			<input type="hidden" name="page" value="[% (source)? source : uri %]" />
			<input type="hidden" name="lang" value="[% language %]" />
			<input type="submit" value="Submit" />
		</p>
	    </form>

	    <script type="text/javascript">

		if (CKEDITOR.instances['editor[% (source)? source : 1 %]']) { delete CKEDITOR.instances['editor[% (source)? source : 1 %]'] };

		//<![CDATA[
		CKEDITOR.replace( "editor[% (source)? source : 1 %]",
		{
    		    filebrowserBrowseUrl : '/admin/images/browse',
    		    filebrowserUploadUrl : '/admin/images/upload'
//    		    filebrowserImageBrowseUrl : '/admin/images/browse',
//    		    filebrowserImageUploadUrl : '/admin/images/upload'
    		    
		});
		//]]>

	    </script>

	</div>

	<div id="source[% source %]_div">
	[% (source)? sources.item(source).content_body : content %]
	</div>
