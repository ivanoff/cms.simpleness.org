[% IF !n.news_hidden || access.add_news %]

    <div class="news">
[% d = n.news_date.substr(0,10).split('-') %]
        <h2>[% t( d? 'News' : 'add news' ) %]</h2>

[% IF access.add_news %]
        <script src="/js/admin/news.js"></script>
[%   PROCESS admin/news/eye.tpl key = news_key hidden = n.news_hidden || !d %]
        <span class='delete cursor_pointer symbol' name="[% news_key %]" alt="[% t('delete') %]">&#206;</span>
        <input type="text" id="datepicker" value="[% d ? d.0 _ '-' _ d.1 _'-' _ d.2 : current_date %]" />
[% ELSE %]
        <div class="date"><h4><b>[% t(month(d.1)) _ ' ' _ d.2 _', ' _ d.0 %]</b></h4></div>
[% END %]

<h2>[% PROCESS editable.tpl value = n.news_name || t('New news header') name = "/admin/news/" _ news_key _ "/update?header" %]</h2>

[% PROCESS editable.tpl value = n.news_body || t('New news body') name = "/admin/news/" _ news_key _ "/update?body" %]

        <br />
[% IF access.add_news %]
[%   PROCESS admin/news/eye.tpl text = 1 key = news_key hidden = n.news_hidden || !d %]
        <br /><br />
[% END %]

	<a href="/news">«[% t('back') %]</a>
    </div>

[% END %]
