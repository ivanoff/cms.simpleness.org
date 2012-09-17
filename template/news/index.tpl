<h2>[% t('News') %]</h2>

[% FOREACH n IN news %]

[% IF access.can_edit_content %]
<a href="/admin/news/edit/[% n.news_id %]"><img border="0" src="/images/btn_edit.gif"></a>
[% END %]

        <small>[% SET d = n.news_date.substr(0,10).split('-'); t(month(d.1)) _ ' ' _ d.2 _', ' _ d.0 %]</small><br>
	<b>[% n.news_name %]</b>
	<p>[% n.news_body %]</p>

[% END %]
