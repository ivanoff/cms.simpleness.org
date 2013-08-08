<h2>[% t('News') %]</h2>

[% IF access.add_news %]

<link href="/css/icon.css" rel="stylesheet">
<script type="text/javascript">
    $(document).ready(function(){
        $('.delete').click(function () {
            save_text( '/admin/news/delete/'+$(this).attr('name'), {}, 'news was deleted'); 
	    $(this).parent().animate({opacity:0}, 700, function(){ $(this).css({display:"none"}); });
	    return false;
        });
    });
</script>

<a href="/admin/news/add"><img border="0" src="/images/btn_plus.gif">[% t('add news') %]</a><br /><br />

[% END %]

[% FOREACH n IN news %]

    <div class="news index">
<small><b>[% SET d = n.news_date.substr(0,10).split('-'); t(month(d.1)) _ ' ' _ d.2 _', ' _ d.0 %]</b></small><br>
&nbsp;
[% IF access.add_news %]
<i class='icon-trash delete' name="[% n.news_key %]" alt="[% t('delete') %]"></i>
[% END %]
	<a href="/news/[% n.news_key %]">[% n.news_name %]</a>
	<br />
	<p>[% n.news_body.remove('(?ims)((<br( /)?>\s*<br( /)?>)|(<p>\s*&nbsp;\s*</p>\s*){2}).*') %]</p>
	<a href="/news/[% n.news_key %]">[% t('more') %]…</a>
    </div>
[% END %]
