<h2>[% t('Gallery manager') %]</h2>

<table>

[% IF gal_id %]

<tr><td>

<h2>
<span id="gal_name">
    [% gallery.${gal_id}.gal_name %]
</span>
</h2>
    [% gallery.${gal_id}.gal_description %]
<span id="gal_edit">
<form method="post">
    <input name="gallery_name_new" value="[% gallery.${gal_id}.gal_name %]"><br>
    <textarea name="gallery_description_new">[% gallery.${gal_id}.gal_description %]</textarea><br>
    <input type="submit" value="[%t('Save')%]">
    <input type="button" id="to_cancel" value="[%t('Cancel')%]">
</form>
</span>
&nbsp;
<a href="#" id="to_edit">[% t('edit') %]</a>
<a href="#" id="to_delete">[% t('delete') %]</a>

<script type="text/javascript">
    $('#gal_edit').hide();
    $('#to_edit').click(function () {
	$('#gal_edit').toggle();
	$('#gal_name').toggle();
	$('#to_edit').toggle();
	$('#to_delete').toggle();
    });
    $('#to_cancel').click(function () {
	$('#gal_edit').toggle();
	$('#gal_name').toggle();
	$('#to_edit').toggle();
	$('#to_delete').toggle();
    });
    $('#to_delete').click(function () {
	if ( confirm ('[% t('Are you sure to delete this gallery?') %]') ) { location.replace('/admin/gallery/delete/[% gal_id %]') }; 
    });
</script>

<script type="text/javascript" src="/editor/swfupload/js/swfupload.js"></script>
<script type="text/javascript" src="/editor/swfupload/js/swfupload.queue.js"></script>
<script type="text/javascript" src="/editor/swfupload/js/fileprogress.js"></script>
<script type="text/javascript" src="/editor/swfupload/js/handlers.js"></script>
<script type="text/javascript">
		var swfu;

		window.onload = function() {
			var settings = {
				flash_url : "/editor/swfupload/swfupload.swf",
				upload_url: "/admin/gallery/upload/[% gal_id %]",
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
      <h2>[% gallery.${gal_id}.gal_name %]</h2>
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
&nbsp; <a href="/admin/gallery/[% gallery.${g}.gal_id %]">[% gallery.${g}.gal_id %] - [% gallery.${g}.gal_name %]</a><br />
[% END %]
<br />
<form action="/admin/gallery" method="post">
    <b>[% t('New gallery') %]:</b><br /> <input name="new_gallery" required><br />
    [% t('Description') %]:<br /> <textarea name="new_gallery_description"></textarea><br />
    <input type="submit" value="[% t('Add new gallery') %]" />
</form>

</td></tr>
</table>
