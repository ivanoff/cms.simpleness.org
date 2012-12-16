<h1>[% t('Gallery') %]</h1>
<table><tr><td>
    <div class="gallery">
        <h2><div id="gallery/[% gal_key %]:header" class="editable">[% gallery.${gal_key}.gal_name %]</div></h2>
	<div id="gallery/[% gal_key %]:body" class="editable">
	    [% gallery.${gal_key}.gal_description %]
	</div>
	<br />
[% IF access.can_manage_gallery %]
	<script type="text/javascript">
	    var gallery_key = "[% gal_key %]"; 
	</script>
	<div class="dropZone">[% t('Drop new images here') %]</div>
[% END %]
      <ul id="gallerys" class="gallerys">
[% FOREACH img IN images %]
	    <li>
		<a href="/[% img.replace('174x174','640x480') %]" title="Image [% n = n + 1 %][% n %]. [% t('Gallery') %]">
		<img src="/[% img %]" alt="">
		</a>
	    </li>
[% END %]
      </ul>
      <br class="clear" />

    </div>
</td></tr></table>

[% IF access.can_manage_gallery %]
	<div class="dropZone">[% t('Drop new images here') %]</div>
	<script src="/js/dropBox.js" type="text/javascript"></script>
[% END %]

<a href="/gallery">&lt;&lt;[% t('back') %]</a>

