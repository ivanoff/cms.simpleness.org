<h1>[% t('Site Manager') %]</h1>


[% IF access.manage_gallery %]
<a href="/gallery">[% t('Gallery manager') %]</a><br />
<a href="/gallery/[% max_gal_id + 1 %]">[% t('add gallery') %]</a><br />
[% END %]

[% IF access.add_news %]
<a href="/admin/news/add">[% t('add news') %]</a><br />
[% END %]

[% IF access.edit_menu %]
<a href="/admin/menu">[% t('edit menu') %]</a><br />
[% END %]

[% IF access.edit_content %]
<a href="/admin/content">[% t('show content pages') %]</a><br />
<!-- 
-->
<a href="/admin/lang/dictionary">[% t('show dictionary') %]</a><br />
<a href="/admin/lang/check">[% t('update language in database') %]</a><br />
[% END %]

<a href="/admin/renew/sitemap">[% t('renew the sitemap') %]</a><br />

[% IF access.edit_users %]
<a href="/admin/users">[% t('edit users') %]</a><br />
[% END %]

[% IF access.edit_user_access %]
<a href="/admin/user/access">[% t('edit access of groups') %]</a><br />
[% END %]

[% IF access.add_subscribe %]
<!-- 
<a href="/admin/subscribe/add">add new subscribe</a><br />
-->
[% END %]

[% IF access.site_update %]
<a href="/admin/update">[% t('Update') %]</a><br />
[% END %]

<a href="/login/change">[% t('Change password') %]</a><br />
<a href="/login/exit">[% t('exit') %]</a><br />

