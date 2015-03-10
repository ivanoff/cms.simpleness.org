[% BLOCK select_type %]
    <input type="checkbox" [% 'checked' IF h.hidden %] name="hide-[% h.column_id %]"> hide
    <select style="width:150px;" name="type-[% h.column_id %]">
        <option value="">[% t('Select field type') %]</option>
[%  FOREACH n IN types %]
        <option value="[% n %]" [% 'selected' IF h.type == n %]>[% n %]</option>
[%  END %]
    </select>
    <b>[% h.name %]</b>
    <br />
[% END %]

<form action="/admin/realtor/config" name="main" method="post">
[% 
  FOREACH h IN headers;
    INCLUDE select_type;
  END 
%]
    <br />
    <input type="button" value="&lt;&lt; [% t('back') %]" onclick="window.location='/admin/realtor/import';">
    <input type="submit" name="submit" value="[% t('Save and view') %] &gt;&gt;">
</form>