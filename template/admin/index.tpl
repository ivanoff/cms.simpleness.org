<h1>[% t('Site Manager') %]</h1>


[% IF access.can_manage_gallery %]
<a href="/admin/gallery">[% t('Gallery manager') %]</a><br />
[% END %]

[% IF access.can_edit_content %]
<a href="/admin/news/add">[% t('add news') %]</a><br />
<a href="/admin/renew/sitemap">[% t('renew the sitemap') %]</a><br />
<a href="/admin/lang_base">[% t('show dictionary') %]</a><br />
<a href="/admin/lang_check">[% t('update language in database') %]</a><br />
[% END %]

[% IF access.can_edit_users %]
<a href="/admin/users">[% t('edit users') %]</a><br />
[% END %]

[% IF access.can_edit_user_access %]
<a href="/admin/user/access">[% t('edit access of groups') %]</a><br />
[% END %]

[% IF access.can_add_subscribe %]
<a href="/admin/subscribe/add">add new subscribe</a><br />
[% END %]

<a href="/login/change">[% t('Change password') %]</a><br />
<a href="/login/exit">[% t('exit') %]</a><br />


