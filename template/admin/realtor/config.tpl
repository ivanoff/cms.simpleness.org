<h2>[% t( 'header manager' ) %]</h2>

[% BLOCK select_type %]
<tr>
    <th>
        <input type="checkbox" [% 'checked' IF h.hidden %] name="hidden-[% h.column_id %]">
    </th>
    <th>
        <input type="checkbox" [% 'checked' IF h.details_hide %] name="details_hide-[% h.column_id %]">
    </th>
    <th>
        <input type="checkbox" [% 'checked' IF h.pdf_hide %] name="pdf_hide-[% h.column_id %]">
    </th>
    <td>
        <select style="width:150px;" name="type-[% h.column_id %]">
            <option value="">[% t('Select field type') %]</option>
[%  FOREACH n IN types %]
            <option value="[% n %]" [% 'selected' IF h.type == n %]>[% t(n) %]</option>
[%  END %]
        </select>
    </td>
    <td>
        <b>[% h.name %]</b>
    </td>
    <td>
        <input value="[% h.dimension %]" name="dimension-[% h.column_id %]" size="5">
    </td>
</tr>
[% END %]

<form action="/admin/realtor/config" name="main" method="post">
<table>
<tr>
    <th colspan="3">[% t( 'hidden in section' ) %]</th>
    <th colspan="2"></th>
</tr>
<tr>
    <th><small>[% t( 'main' ) %]</small></th>
    <th><small>[% t( 'Details' ) %]</small></th>
    <th><small>[% t( 'PDF' ) %]</small></th>
    <th>[% t( 'type of field' ) %]</th>
    <th>[% t( 'name' ) %]</th>
    <th>[% t( 'dimension' ) %]</th>
    <th></th>
</tr>
[%
  FOREACH h IN headers;
    INCLUDE select_type;
  END
%]
</table>
    <br />
    <input type="button" value="&lt;&lt; [% t('back') %]" onclick="window.location='/admin/realtor/import';">
    <input type="submit" name="submit" value="[% t('Save and view') %] &gt;&gt;">
</form>