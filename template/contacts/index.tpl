<script type="text/javascript">
    $(document).ready(function(){
	$('#att').hide();
	$('#show_att').change(function () {
	    $('#att').toggle();
	});
    });
</script>

<form action="/contacts" name="main" method="post" enctype="multipart/form-data">

<table cellSpacing="1" cellPadding="4">
<tbody>

<tr>
<td align="right">[% t('Your name') %]: </td>
<td align="left"><input name="name" value='' id="name" autofocus required> </td></tr>

<tr>
<td align="right">[% t('Your') %] e-mail: </td>
<td align="left"><input name="email" value='' id="email" type="email" required> </td></tr>

<tr>
<td align="right" valign="top">[% t('Message') %]: </td>
<td align="left"><textarea name="text" rows=6 cols=55 id="text"></textarea></td></tr>

<tr>
<td align="right" valign="top">[% t('Attach a file') %]: </td>
<td align="left">
<input type="checkbox" name="file1att" id="show_att"> 
<span id="att">
    <input type="file" name="file1"><br />
    <small>[% t('Accepted formats') %]: jpg,jpeg,png,pdf,txt,doc,docx,rtf,xls,tar,gz</small>
</span>
</td></tr>

<tr align="left">
<td><input name="ref" value='[% env('HTTP_REFERER') %]' type="hidden"></td>
<td>
<input type="submit" value='[% t('Send message') %]'>
</td></tr>

</tbody></table>

</form>

