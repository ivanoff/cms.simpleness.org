<h2>[% t('News') %]</h2>

[% IF access.add_news %]
    <script src="/js/admin/news.js"></script>
    <span class="symbol">&#193;</span> <a href="/news/[% news_max_key %]">[% t('add news') %]</a><br /><br />
[% END %]

[% FOREACH n IN news %]
[% NEXT IF n.news_hidden && !access.add_news %]

<div class="news index">
    <div class="date">
    <h4>
[% IF access.add_news %]
[%   PROCESS admin/news/eye.tpl key = n.news_key hidden = n.news_hidden %]
        <span class='delete cursor_pointer symbol' name="[% n.news_key %]" alt="[% t('delete') %]">&#206;</span>
[% END %]
        <b>[% SET d = n.news_date.substr(0,10).split('-'); t(month(d.1)) _ ' ' _ d.2 _', ' _ d.0 %]</b>
    </h4>
    </div>
    <h3>
        <a href="/news/[% n.news_key %]">[% n.news_name %]</a>
    </h3>
    <p>
        [% n.news_body.remove('(?ims)((<br( /)?>\s*<br( /)?>)|(<p>\s*&nbsp;\s*</p>\s*){2}).*') %] 
    </p>
    <p>
        <a href="/news/[% n.news_key %]"><small>[% t('read more') %]…</small></a>
    </p>
</div>
[% END %]
