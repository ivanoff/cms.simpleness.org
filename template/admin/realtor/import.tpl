<form action="/admin/realtor/import" name="main" method="post" enctype="multipart/form-data">

[% t('Select file to import') %]
<br />
<input type="file" name="file"> 
<small>[% t('Accepted formats') %]: xlsx,xls,csv</small>
<br />
<input type="submit" value='[% t('Send file') %]'>
<input type="button" value="[% t('cancel') %]" onclick="window.location='/realtor';">
</form>
