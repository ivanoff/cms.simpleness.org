<h2>[% t('Register') %] | <a href="/login">[% t('Login') %]</a></h2>

<script language="javascript">
function validate(form) {
    if(document.getElementById('password').value != document.getElementById('password_r').value) {
	alert('[% t('Your passwords do not match') %]');
	return false;
    }
    return true;
}
</script>

<div id="contact_form">

<form method="post" action="/login/register" onsubmit="return validate();">

<!--
[% t('Your login') %]: <br /><input type="text" name="login" class="required input_field" onBlur="ask('/ajax/check_login/'+this.value, 'logindiv')" />
<span id='logindiv'></span><br />
-->

[% t('Your name') %]: <br /><input name="name" required /><br />
[% t('Your email') %]: <br /><input name="login" required /><br />
[% t('Your password') %]: <br /><input type="password" name="password" required /><br />
[% t('Repeat Your password') %]: <br /><input type="password" name="password_r" required /><br />

<br />
<input name="ref" value="[% env('HTTP_REFERER') %]" type="hidden">
<input style="font-weight: bold;" type="submit" name="submit" />

</form>

</div>