<h2>[% t('News') %]</h2>

[% IF access.add_news %]
    [% IF news.0%]
        <a href="/admin/news/add"><img border="0" src="/images/btn_plus.gif">[% t('add news') %]</a><br /><br />
    [% ELSE %]
        <input type="text" id="datepicker" value="[% current_date %]" />
        <h2><div id="news/[% n.news_key %]:header" class="editable">New news header</div></h2>
	<div id="news/[% n.news_key %]:body" class="editable">New news body</div>
    [% END %]
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" />
<script>
    $(function() {
        $( "#datepicker" ).datepicker({
            onClose: function(date) {
                save_text( "news/[% n.news_key %]:date" , date );
                show_info( "date saved" );
              }
            , changeMonth: true
            , changeYear: true
            , dateFormat: 'yy-mm-dd'
        });
    });
</script>
[% END %]

[% FOREACH n IN news %]

[% IF access.add_news %]
<input type="text" id="datepicker" value="[% SET d = n.news_date.substr(0,10).split('-'); d.0 _ '-' _ d.1 _'-' _ d.2 %]" />
<a href="/admin/news/delete/[% n.news_id %]"><img border="0" src="/images/btn_delete.gif"></a>
[% ELSE %]
<small><b>[% SET d = n.news_date.substr(0,10).split('-'); t(month(d.1)) _ ' ' _ d.2 _', ' _ d.0 %]</b></small>
[% END %]
    <div class="news">

        <h2><div id="news/[% n.news_key %]:header" class="editable">[% n.news_name %]</div></h2>
	<div id="news/[% n.news_key %]:body" class="editable">
	    [% n.news_body %]
	</div>
	<a href="/news">«[% t('back') %]</a>

    </div>
[% END %]

