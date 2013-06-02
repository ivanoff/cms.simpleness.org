<h2>[% t('Content') %]</h2>

<table>
<tr>
    <td></td>
    <td></td>
[% FOREACH l IN config.languages.sort %]
    <td align="center">
        <img src="/images/flags/[% l %].gif"> 
    </td>
[% END %]
</tr>
[% FOREACH page IN pages %]
<tr>
    <td><a href="/admin/content/delete/[% page.content_id %]">x</a></td>
    <td>[% page.content_page || '/' %]</td>
    [% FOREACH l IN config.languages.sort %]
    <td align="center">
        <div id="link-[% content.${l}.${${page.content_page}} %]">
        <a href="//[% l %].[% config.site %]/[% page.content_page %]">[% (content.${l}.${${page.content_page}})? 'v' : '' %]</a>
        <div id="content-[% content.${l}.${${page.content_page}} %]"></div>
        </div>
    </td>
    [% END %]
</tr>
[% END %]
</table>

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
