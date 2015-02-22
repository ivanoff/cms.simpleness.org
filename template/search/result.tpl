<h2>[% t('Search result for') %] [% text %]</h2>
[% i = 0 %]
[% FOREACH r IN results %]
    <div>[% i = i + 1; i %]. <a href="[% r.link || '/' %]">[% r.body %]</a></div>
[% END %]

<br /><br />

[% INCLUDE search/index.tpl %]
