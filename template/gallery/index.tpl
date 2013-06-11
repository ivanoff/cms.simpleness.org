<h1>[% t('Gallery') %]</h1>

[% IF access.manage_gallery %]
<a href="/admin/gallery/add"><img border="0" src="/images/btn_plus.gif">[% t('add gallery') %]</a><br /><br />
[% END %]

[% FOREACH g IN gallery.keys %]
&nbsp; <a href="/gallery/[% gallery.${g}.gal_key %]">[% gallery.${g}.gal_name %]</a><br />
[% END %]

