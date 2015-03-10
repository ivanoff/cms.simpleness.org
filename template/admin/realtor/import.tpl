<form action="/admin/realtor/import" name="main" method="post" enctype="multipart/form-data">

[% t('Select file to import') %]
<br />
<input type="file" name="file"> 
<small>[% t('Accepted formats') %]: xlsx,xls,csv,tar,gz</small>
<br />
<input type="submit" value='[% t('Send file') %]'>

</form>
