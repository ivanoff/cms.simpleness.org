<form action="/admin/realtor/import" name="main" method="post" enctype="multipart/form-data">

[% t('Select file to import') %]
<br />
<input type="file" name="file"> 
<small>[% t('Accepted formats') %]: xlsx,xls,csv</small>
<br />
<input type="submit" value='[% t('Send file') %]'>
<input type="button" value="[% t('cancel') %]" onclick="window.location='/realtor';">
<br /><br />
[% t('Insert URL of spreadsheet GoogleDocs') %]
<br />
<input name="google_spreadsheet">
<input type="submit" value='[% t('Import from GoogleDocs') %]'>
<input type="button" value="[% t('cancel') %]" onclick="window.location='/realtor';">
<br /><br />
</form>