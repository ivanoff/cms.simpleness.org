	<a href="/[% config_images.PATH %]/[% img.gal_key %]/640x480/[% img.img_name %]" title="Image [% n = n + 1 %][% n %]. [% t('Gallery') %]">
	<img src="/[% config_images.PATH %]/[% img.gal_key %]/[% config_images.SIZE.0 %]/[% img.img_name %]" alt="" id="i[% img.img_id %]">
	</a>
[% IF access.manage_gallery %]
	<img align="top" class="delete" name="i[% img.img_id %]" alt="[% t('delete') %]" src="/images/btn_delete.gif">
	<img align="top" class="move-right" name="i[% img.img_id %]" alt="[% t('delete') %]" src="/images/btn_delete.gif">
[% END %]
