<h2>add subscribe</h2>

<script type="text/javascript">
    function fill_all( ) {
	[% FOREACH l IN config.languages.sort %]
	    document.getElementById('subj_[%l%]').value=document.getElementById('subj_default').value;
	    document.getElementById('body_[%l%]').value=document.getElementById('body_default').value;
	[% END %]
    }
</script>

<form method="post" enctype="multipart/form-data">
[% t('Date') %]: <input type="text" name="date" value="[% current_date %] [% current_time %]" /><br /><br />

<b>default</b> ( [% subscribers.${m} %] subscribers )

subj: <input type="text" name="subj_default" id="subj_default" value=""/><br />
<textarea name="body_default" id="body_default" rows=6 cols=100></textarea>
<br />
<small><sup>*</sup>use [name] for name</small>
<br />
<input type="button" value="fill all languages" onclick="fill_all()"> <input type="submit" value="save and generate emails">

[% FOREACH l IN config.languages.sort %]

<hr />

<b>[% l %]</b> ( [% subscribers.${l} %] subscribers )

subj: <input type="text" name="subj_[% l %]" id="subj_[% l %]" value=""/><br />
<textarea name="body_[% l %]" id="body_[% l %]" rows=6 cols=100></textarea><br />


[% END %]
<div id="contact_form">

<br />
<input type="hidden" name="generate" value="emails">
<input type="submit" value="save and generate emails">

</form>

</div>