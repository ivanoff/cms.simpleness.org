<h1>[% t('Add news') %]</h1>

<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" />
<script>
    $(function() {
        $( "#datepicker" ).datepicker({
              changeMonth: true
            , changeYear: true
            , dateFormat: 'yy-mm-dd'
        });
    });
</script>

<br />
[% t('Date') %]: <input type="text" id="datepicker" value="[% current_date %]" />

<h3><div id="/admin/news/add/update?header" class="editable silent">[% t('New news header') %]</div></h3>

<div id="/admin/news/add/update?body" class="editable silent">[% t('New news body') %]</div>

<br />
<input type="button" value="[% t('Publish the news') %]" id="post_news">

<script>
    $(document).ready(function(){
        $( "#post_news" ).click(function() {
            if( save_text( '/admin/news/add/update', {
                              'date'   : $("#datepicker").attr('value')
                            , 'header' : $("div[id*='/admin/news/add/update?header']").html()
                            , 'body'   : $("div[id*='/admin/news/add/update?body']").html()
                        }, 'news posted' )
            ) {
                setTimeout(function() {
                    window.location.href='/news';
                }, 1000);
            };
        });
    });
</script>
