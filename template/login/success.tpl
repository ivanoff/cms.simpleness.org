<h2>[% t('Wellcome back') %], [% name %]</h2>

<br />

[% PROCESS admin/index.tpl %]

<!--
[% IF access.edit_user_access %]
            <a href="/admin">[% t('Admin page') %]</a><br />
[% ELSE %]
            <a href="/user">[% t('User page') %]</a><br />
[% END %]
            <a href="/">[% t('Home') %]</a><br />
-->