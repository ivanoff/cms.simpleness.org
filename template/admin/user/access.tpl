<h2>Access</h2>
<form method="post" enctype="multipart/form-data">

[% IF access.edit_user_access %]

[%
    access_names = { 
	'edit_user_access' => 'can edit this access',
	'edit_content' => 'can edit content', 
	'email_page' => 'can send emails from the site', 
	'add_subscribe' => 'can add new subscribe', 
	'view_addthis' => 'view addthis area',
	'settings' => 'can edit settings',
	'import_base' => 'can import base',
	'manage_gallery' => 'can manage gallery',
	'add_news' => 'can add and edit news',
	'edit_menu' => 'edit main menu',
	'print_page' => 'can print page',
	'site_update' => 'can update site scripts',
	'realtor_import' => 'import realtor database',
    }
%]

<table>
    <tr>
	<th>
        </th>
[% FOREACH n IN groups %]
	<th>
	    [% n.group_name || 'default' %]
        </th>
[% END %]
	<th>
        </th>
    </tr>
[% FOREACH a IN access_names.keys.sort %]
    <tr>
	<th align="right">
	    [% a %]
        </th>
[% FOREACH n IN groups %]
[% check =  ( rules.${n.group_id}.${a} || ( session('sgroup') == n.group_name && access.${a} ) )? 'checked="checked"' : '' %]
	<td align="center">
	    <input type="checkbox" value="1" name="[% n.group_name %]-[% a %]" [% check %] >
        </td>
[% END %]
	<td>
	    [% access_names.${a} %]
        </td>
    </tr>
[% END %]
    <tr><th><input type="hidden" name="access" value="1"></th><td colspan="3"><input type="submit"></td></tr>
</table>
[% END %]

</form>
