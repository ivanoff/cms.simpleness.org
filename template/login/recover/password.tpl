<h2>[% t('Recover password') %]</h2>

<div id="contact_form">

<script language="javascript">
function validate(form) {
    if(document.getElementById('password').value != document.getElementById('password_r').value) {
	alert('[% t('Your passwords do not match') %]');
	return false;
    }
    return true;
}
</script>

<form method="post" enctype="multipart/form-data" onsubmit="return validate();">

<br />
[% t('Your new passsword') %]: <br /><input type="password" name="password" id="password" /><br />

[% t('Repeat your new password') %]: <br /><input type="password" name="password_r" id="password_r" /><br />

<br />
<input style="font-weight: bold;" type="submit" name="Save new password" />

</form>

</div>