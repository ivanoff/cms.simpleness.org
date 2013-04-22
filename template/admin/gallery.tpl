<h2>[% t('Gallery manager') %]</h2>

<table>

[% IF gal_key %]

<tr><td>

<h2><div id="/admin/gallery/[% gal_key %]/update?header" class="editable">[% gallery.${gal_key}.gal_name %]</div></h2>
<div id="/admin/gallery/[% gal_key %]/update?body" class="editable">
    [% gallery.${gal_key}.gal_description %]
</div>
<a href="#" id="to_delete">[% t('delete') %]</a>
<script type="text/javascript">
    $('#to_delete').click(function () {
	if ( confirm ('[% t('Are you sure to delete this gallery?') %]') ) { location.replace('/admin/gallery/delete/[% gal_key %]') }; 
    });
</script>

<script type="text/javascript" src="/js/swfupload/js/swfupload.js"></script>
<script type="text/javascript" src="/js/swfupload/js/swfupload.queue.js"></script>
<script type="text/javascript" src="/js/swfupload/js/fileprogress.js"></script>
<script type="text/javascript" src="/js/swfupload/js/handlers.js"></script>
<script type="text/javascript">
		var swfu;

		window.onload = function() {
			var settings = {
				flash_url : "/js/swfupload/swfupload.swf",
				upload_url: "/admin/gallery/upload/[% gal_key %]",
				post_params: {"_SESSION_ID" : "[% session('_SESSION_ID') %]"},
				file_size_limit : "1073741824",
				file_types : "*.*",
				file_types_description : "All Files",
				file_upload_limit : 100,
				file_queue_limit : 0,
				custom_settings : {
					progressTarget : "fsUploadProgress",
					cancelButtonId : "btnCancel"
				},
				debug: false,

				// Button settings
				button_image_url: "/images/btn_plus.gif",
				button_width: "270",
				button_height: "29",
				button_placeholder_id: "spanButtonPlaceHolder",
				button_text: '<span class="theFont">&nbsp;[%t('Select files to upload')%]</span>',
				button_text_style: ".theFont { font-size: 18; }",
				button_text_left_padding: 12,
				button_text_top_padding: 8,
				
				// The event handler functions are defined in handlers.js
				file_queued_handler : fileQueued,
				file_queue_error_handler : fileQueueError,
				file_dialog_complete_handler : fileDialogComplete,
				upload_start_handler : uploadStart,
				upload_progress_handler : uploadProgress,
				upload_error_handler : uploadError,
				upload_success_handler : uploadSuccess,
				upload_complete_handler : uploadComplete,
				queue_complete_handler : queueComplete	// Queue plugin event
			};

			swfu = new SWFUpload(settings);
	     };
	</script>

<div id="content">
	<form id="form1" action="/admin/gallery" method="post" enctype="multipart/form-data">

			<div class="fieldset flash" id="fsUploadProgress">
			<span class="legend"></span>
			</div>
		<div id="divStatus"></div>
			<div>
				<span id="spanButtonPlaceHolder"></span>
				<input id="btnCancel" type="button" value="[% t('Cancel all uploads') %]" onclick="swfu.cancelQueue();" disabled="disabled" />
			</div>

	</form>
</div>

</div>
</td></tr>
<tr><td>
<br />

    <div class="gallery">
      <ul>
[% FOREACH img IN images %]
        <li><a rel="gallery_group" href="/[% img.replace('174x174','640x480') %]" title="Image [% n = n + 1 %][% n %]"><img src="/[% img %]" alt="" /></a> 
	<img align="top" class="delete" name="[% img %]" alt="[% t('delete') %]" src="/images/btn_delete.gif">
[% END %]
      </ul>
      <br class="clear" />
    </div>
<script type="text/javascript">
    $('.delete').click(function () {
	if ( confirm ('[% t('Are you sure to delete this image?') %]') ) 
		{ location.replace('/admin/gallery/delete/'+$(this).attr('name')) }; 
	return false;
    });
</script>

</td></tr>
[% END %]

<tr><td>
<b>[% t('Please, select gallery') %]</b><br />
[% FOREACH g IN gallery.keys %]
&nbsp; <a href="/admin/gallery/[% gallery.${g}.gal_key %]">[% gallery.${g}.gal_key %] - [% gallery.${g}.gal_name %]</a><br />
[% END %]
<br />
<form action="/admin/gallery" method="post">
    <b>[% t('New gallery') %]:</b><br /> <input name="new_gallery" required><br />
    [% t('Description') %]:<br /> <textarea id="gallery_description_new" name="new_gallery_description"></textarea><br />

    <input type="submit" value="[% t('Add new gallery') %]" />
</form>

</td></tr>
</table>
