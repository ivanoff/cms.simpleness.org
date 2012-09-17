<h2>Access</h2>
<form method="post" enctype="multipart/form-data">

[% IF access.can_edit_user_access %]

[%
    access_names = { 
	'can_edit_user_access' => 'can edit this access',
	'can_edit_content' => 'can edit content', 
	'can_email_page' => 'can send emails from the site', 
	'can_add_subscribe' => 'can add new subscribe', 
	'can_view_addthis' => 'view addthis area',
	'can_settings' => 'can edit settings',
	'can_import_base' => 'can import base',
	'can_manage_gallery' => 'can manage gallery',
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
	<td align="center">
	    <input type="checkbox" value="1" name="[% n.group_name %]-[% a %]" [% 'checked="checked"' IF rules.${n.group_id}.${a} %] >
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
