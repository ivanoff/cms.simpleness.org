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

<h2><div id="admin/news/add:header" class="editable silent">New news header</div></h2>

<div id="admin/news/add:body" class="editable silent">New news body</div>

