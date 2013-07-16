<h1>[% t('Gallery') %]</h1>

[% IF access.manage_gallery %]

<link href="/css/icon.css" rel="stylesheet">
<script type="text/javascript">
    $(document).ready(function(){
        $('.delete').click(function () {
            save_text( '/admin/gallery/delete/'+$(this).attr('name'), {}, 'gallery was deleted'); 
	    $(this).parent().animate({opacity:0}, 700, function(){ $(this).css({display:"none"}); });
	    return false;
        });
    });
</script>

<a href="/gallery/[% max_gal_id + 1 %]"><img border="0" src="/images/btn_plus.gif">[% t('add gallery') %]</a><br /><br />
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
<img align="top" src="/[% config_images.PATH %]/[% g %]/[% config_images.SIZE.0 %]/[% img.${g}.img_name %]" alt="[% gallery.${g}.gal_name %]">
</figure>

[% END %]

</div>
