<h2>[% t('Search result for') %] [% text %]</h2>
[% i = 0 %]
[% FOREACH r IN results %]
    <div>[% i = i + 1; i %]. <a href="[% (r.news_body)? '/news/' _ r.news_key : r.content_page || '/' %]">[% r.body %]</a></div>
[% END %]

<br /><br />

[% INCLUDE search/index.tpl %]