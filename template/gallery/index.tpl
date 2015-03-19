<h1>[% t('Gallery') %]</h1>

[% IF access.manage_gallery %]
<script src="/js/admin/gallery.js"></script>
<span class="symbol">&#193;</span> <a href="/gallery/[% max_gal_id + 1 %]">[% t('add gallery') %]</a><br /><br />
[% END %]

<div style="display: inline-block;" class="gallery">

[% FOREACH g IN gallery.keys %]

<figure>
<legend>
<h3>
[% IF access.manage_gallery %]
<span class='cursor_pointer symbol delete' name="[% g %]" alt="[% t('delete') %]">&#205;</span>
[% END %]
<a href="/gallery/[% gallery.${g}.gal_key %]">[% gallery.${g}.gal_name %]</a>
</h3>
</legend>
<a href="/gallery/[% gallery.${g}.gal_key %]"><img align="top" src="/[% config_images.PATH %]/[% g %]/[% config_images.SIZE.0 %]/[% img.${g}.img_name %]" alt="[% gallery.${g}.gal_name %]"></a>
</figure>

[% END %]

</div>
