<h2>[% t('Add news') %]</h2>

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

[% t('Date') %]: <input type="text" id="datepicker" value="[% current_date %]" />

<h2><div id="/admin/news/add/update?header" class="editable silent">New news header</div></h2>

<div id="/admin/news/add/update?body" class="editable silent">New news body</div>

<input type="button" value="[% t('post news') %]" id="post_news">

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
