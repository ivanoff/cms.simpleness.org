<h2>[% t('Content') %]</h2>


[% FOREACH page IN content %]
<div id="link-[% page.content_id %]">
    [% page.lang %], <a href="#">[% page.content_page || '/' %]</a>
    <div id="content-[% page.content_id %]"></div>
</div>
[% END %]

<script type="text/javascript">
    $('#link-1615').click(function () {
//	$('#content-1615').innerHTML='aaaa';
//	$('#content-1615').textContent='aaaa';
//	$('#content-1615').text='aaaa';
//alert (
$.ajax({url:"/admin/content/1630",type:"GET",async:!1,global:!1,"throws":!0, success : function(data, textStatus, XMLHttpRequest) { alert (data); }});

//);



    });
</script>
