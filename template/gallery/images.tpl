<script src="/js/lightbox.js"></script>
<script src="/js/gallery.js"></script>
[% IF access.manage_gallery %]
    <script src="/js/dropBox.js"></script>
    <script src="/js/admin/gallery.js"></script>
[%   IF upload_id %]
        <script type="text/javascript">
            var gallery_key = "[% upload_id %]"; 
        </script>
        <div class="dropZone"><b>[% t('Drop new images here') %]</b></div>
[%   END %]
[% END %]

    <div class="gallery">
      <ul id="gallerys" class="gallerys">
[% FOREACH img IN images %]
	    <li>
[% IF access.manage_gallery %]
        <div class="ear" style="width:100px">
	<span class="cursor_pointer symbol">&#226;</span>
        <span class='rotate_image cursor_pointer symbol' name="[% img.gal_key %]/[% img.img_name %]" id="[% img.img_id %]">&#169;</span>
        <span class='unrotate_image cursor_pointer symbol' name="[% img.gal_key %]/[% img.img_name %]" id="[% img.img_id %]">&#170;</span>
        <span class='delete_image cursor_pointer symbol' name="[% img.gal_key %]/[% img.img_name %]" id="[% img.img_id %]" alt="[% t('delete') %]">&#206;</span>
        </div>
[% END %]
	<a href="/[% config_images.PATH %]/[% img.gal_key %]/640x480/[% img.img_name %]" title="Image [% n = (n)? n + 1 : 1 %][% n %]. [% t('Gallery') %]">
	<img align="top" src="/[% config_images.PATH %]/[% img.gal_key %]/[% config_images.SIZE.0 %]/[% img.img_name %]" alt="" id="i[% img.img_id %]"></a>
	    </li>
[% END %]
[% IF access.manage_gallery && upload_id %]
	    <li class='last_li'>
	        <div class="dropZone" style="width:200px;height:200px;"><b>[% t('Drop new images here') %]</b></div>
	    </li>
[% END %]
      </ul>
      <br class="clear" />
    </div>

