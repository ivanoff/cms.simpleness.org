<h2>[% t('Login') %] | <a href="/login/register">[% t('Register') %]</a></h2>

<b>[% t('Please enter your login and password') %]</b> &nbsp; 
<small>(<a href="/login/recover">[% t('Recover password') %]</a>)</small>

<div id="contact_form">

<form method="post" action="/login" enctype="multipart/form-data">

<br />
[% t('Your login:') %] <br />
<input type="text" name="login" required autofocus /><br />
[% t('Your password:') %] <br />
<input type="password" name="password" required /><br />

<br />
<input name="ref" value="[% env('HTTP_REFERER') %]" type="hidden">
<input style="font-weight: bold;" type="submit" name="submit" />
</form>

<br /><br />

<a href="/login/register">[% t('Register') %]</a>
|
<a href="/login/recover">[% t('Recover password') %]</a>

</div>