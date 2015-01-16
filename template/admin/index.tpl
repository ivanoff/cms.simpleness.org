<h1>[% t('Admin page') %]</h1>


[% IF access.add_news %]
<span class="col">
<b><i class="icon-time"></i> [% t('News') %]</b><br />
<a href="/admin/news/add"><i class="icon-plus-sign"></i> [% t('add news') %]</a><br />
<a href="/news">[% t('news manager') %]</a><br />
</span>
[% END %]

[% IF access.manage_gallery %]
<span class="col">
<b><i class="icon-picture"></i> [% t('Gallery') %]</b><br />
<a href="/gallery/[% max_gal_id + 1 %]"><i class="icon-plus-sign"></i> [% t('add gallery') %]</a><br />
<a href="/gallery">[% t('gallery manager') %]</a><br />
</span>
[% END %]

[% IF access.edit_menu %]
<span class="col">
<b><i class="icon-tasks"></i> [% t('Menu') %]</b><br />
<a href="/admin/menu">[% t('edit menu') %]</a><br />
</span>
[% END %]

<div class="x"></div>

<span class="col">
<b><i class="icon-user"></i> [% session('sname') %]</b><br />
[% IF access.edit_content %]
<a href="/admin/templates">[% t('change template') %]</a><br />
[% END %]
[% IF access.edit_users %]
<a href="/admin/users">[% t('edit users') %]</a><br />
[% END %]
[% IF access.edit_user_access %]
<a href="/admin/user/access">[% t('edit access of groups') %]</a><br />
[% END %]
<a href="/login/change">[% t('change password') %]</a><br />
<a href="/login/exit">[% t('exit') %]</a><br />
</span>

[% IF access.edit_content %]
<span class="col">
<b><i class="icon-th"></i> [% t('Content') %]</b><br />
<a href="/admin/content">[% t('show content pages') %]</a><br />
<a href="/admin/lang/dictionary">[% t('show dictionary') %]</a><br />
</span>
[% END %]

[% IF access.add_subscribe %]
<!-- 
<span class="col">
<b><i class="icon-download-alt"></i> [% t('Update') %]</b><br />
<a href="/admin/subscribe/add">add new subscribe</a><br />
</span>
-->
[% END %]

[% IF access.site_update %]
<span class="col">
<b><i class="icon-download-alt"></i> [% t('Update') %]</b><br />
<a href="/admin/lang/check">[% t('update language') %]</a><br />
<a href="/admin/renew/sitemap">[% t('renew the sitemap') %]</a><br />
<a href="/admin/update">[% t('update') %]</a><br />
</span>
[% END %]

<div class="x"></div>
