<h2>[% t('News') %]</h2>

[% IF access.add_news %]
<a href="/admin/news/add"><img border="0" src="/images/btn_plus.gif">[% t('add news') %]</a><br /><br />
[% END %]

[% FOREACH n IN news %]

<small><b>[% SET d = n.news_date.substr(0,10).split('-'); t(month(d.1)) _ ' ' _ d.2 _', ' _ d.0 %]</b></small>
&nbsp;
[% IF access.add_news %]
<a href="/admin/news/edit/[% n.news_id %]"><img border="0" src="/images/btn_edit.gif"></a>
<a href="/admin/news/delete/[% n.news_id %]"><img border="0" src="/images/btn_delete.gif"></a>
[% END %]
    <div class="news">
	<h3>[% n.news_name %]</h3>
	<br />
	<p>[% n.news_body %]</p>
	<a href="/news">«[% t('back') %]</a>
    </div>
[% END %]
