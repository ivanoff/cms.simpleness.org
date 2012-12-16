<h2>[% t('add news') %]</h2>

<div id="contact_form">

<form method="post" enctype="multipart/form-data">

[% t('Date') %]: <br /><input type="text" name="date" value="[% IF n.0.news_date %][% n.0.news_date %][% ELSE %][% current_date %] [% current_time %][% END %]" /><br />
[% t('Title') %]: <br /><input type="text" name="name" value="[% n.0.news_name %]"/><br />
[% t('Content') %]: <br />
<textarea class="ckeditor__" cols="80" rows="10" id="news_editor[% n.0.news_key %]" name="body">[% n.0.news_body %]</textarea><br />

<small>key: [% n.0.news_key %]</small>
<br />
<input style="font-weight: bold;" type="submit" name="submit" />

</form>

</div>

	    <script type="text/javascript">

		if (CKEDITOR.instances['news_editor[% n.0.news_key %]']) { delete CKEDITOR.instances['news_editor[% n.0.news_key %]'] };

		//<![CDATA[
		CKEDITOR.replace( "news_editor[% n.0.news_key %]",
		{
    		    filebrowserBrowseUrl : '/admin/images/browse',
    		    filebrowserUploadUrl : '/admin/images/upload'
		});
		//]]>

	    </script>
