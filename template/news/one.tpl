<script type="text/javascript">
    $(document).ready(function(){
        $('.delete').click(function () {
            if( save_text( '/admin/news/delete/'+$(this).attr('name'), {}, 'news was deleted') ) {
                setTimeout(function() {
                    window.location.href='/news';
                }, 1000);
            }
        });
    });
</script>

<h2>[% t('News') %]</h2>

[% FOREACH n IN news %]

[% IF access.add_news %]
<a href="/admin/news/add"><img border="0" src="/images/btn_plus.gif">[% t('add news') %]</a><br /><br />

<script>
    $(function() {
        $( "#datepicker" ).datepicker({
            onClose: function(date) {
                save_text( "/admin/news/[% n.news_key %]/update?date" , date );
                show_info( "date saved" );
              }
            , changeMonth: true
            , changeYear: true
            , dateFormat: 'yy-mm-dd'
        });
    });
</script>
[% END %]

    <div class="news">

[% IF access.add_news %]
<i class='icon-trash delete' name="[% n.news_key %]" alt="[% t('delete') %]"></i>
<input type="text" id="datepicker" value="[% SET d = n.news_date.substr(0,10).split('-'); d.0 _ '-' _ d.1 _'-' _ d.2 %]" />
[% ELSE %]
<small><b>[% SET d = n.news_date.substr(0,10).split('-'); t(month(d.1)) _ ' ' _ d.2 _', ' _ d.0 %]</b></small>
[% END %]

        <h2><div id="/admin/news/[% n.news_key %]/update?header" class="editable">[% n.news_name %]</div></h2>
	<div id="/admin/news/[% n.news_key %]/update?body" class="editable">
	    [% n.news_body %]
	</div>
	<a href="/news">«[% t('back') %]</a>

    </div>
[% END %]

