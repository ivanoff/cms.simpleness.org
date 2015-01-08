[% IF access.manage_gallery %]
        <div class="ear" style="width:100px">
	<i class="icon-move"></i>
        <i class='icon-repeat rotate_image' name="i[% img.img_id %]"></i>
        <i class='icon-trash delete_image' name="i[% img.img_id %]" alt="[% t('delete') %]"></i>
        </div>
[% END %]
	<a href="/[% config_images.PATH %]/[% img.img_path %]/[% img.gal_key %]/640x480/[% img.img_name %]" title="Image [% n = (n)? n + 1 : 1 %][% n %]. [% t('Gallery') %]">
	<img align="top" src="/[% config_images.PATH %]/[% img.img_path %]/[% img.gal_key %]/[% config_images.SIZE.0 %]/[% img.img_name %]" alt="" id="i[% img.img_id %]"></a>
