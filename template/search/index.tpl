<h2>[% t('Search') %]</h2>

<form method="get" action="/search">

<input type="text" name="text" required autofocus info="[% t('text to search') %]" value="[% text %]" />
<input style="font-weight: bold;" type="submit" value="[% t('Search') %] &gt;&gt;" />
<br /><br />

</form>
