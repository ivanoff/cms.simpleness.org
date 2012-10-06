<h2>[% t('add news') %]</h2>

<div id="contact_form">

<form method="post" enctype="multipart/form-data">

[% t('Date') %]: <br /><input type="text" name="date" value="[% IF n.0.news_date %][% n.0.news_date %][% ELSE %][% current_date %] [% current_time %][% END %]" /><br />
[% t('Title') %]: <br /><input type="text" name="name" value="[% n.0.news_name %]"/><br />
[% t('Content') %]: <br /><textarea name="body" rows=6 cols=55>[% n.0.news_body %]</textarea><br />
<small>key: [% n.0.news_key %]</small>
<br />
<input style="font-weight: bold;" type="submit" name="submit" />

</form>

</div>