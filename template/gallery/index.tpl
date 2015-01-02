<h1>[% t('Gallery') %]</h1>

[% IF access.manage_gallery %]
<script src="/js/admin/gallery.js"></script>
<a href="/gallery/[% max_gal_id + 1 %]"><i class="icon-plus-sign"></i> [% t('add gallery') %]</a><br /><br />
[% END %]

<div style="display: inline-block;">

[% FOREACH g IN gallery.keys %]

<figure style="padding:20px; float: left;">
<legend>
<h3>
[% IF access.manage_gallery %]
<i class='icon-trash delete' name="[% g %]" alt="[% t('delete') %]"></i>
[% END %]
<a href="/gallery/[% gallery.${g}.gal_key %]">[% gallery.${g}.gal_name %]</a>
</h3>
</legend>
<a href="/gallery/[% gallery.${g}.gal_key %]"><img align="top" src="/[% config_images.PATH %]/[% g %]/[% config_images.SIZE.0 %]/[% img.${g}.img_name %]" alt="[% gallery.${g}.gal_name %]"></a>
</figure>

[% END %]

</div>
