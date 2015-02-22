<form method="get" action="/search">
<input type="search" name="text" required [% autofocus? 'autofocus' : '' %] placeholder="[% t('text to search') %]" value="[% text %]" />
<input type="submit" value="[% t('Search') %] &gt;&gt;" />
</form>
