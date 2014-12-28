<h1>[% t('Gallery') %]</h1>
<script src="/js/lightbox.js"></script>
<script src="/js/gallery.js"></script>
[% IF access.manage_gallery -%]
<script src="/js/dropBox.js"></script>
[% END -%]

<table><tr><td>
    <div class="gallery">
        <h2>
[% PROCESS editable.tpl name='/admin/gallery/' _ gal_key _ '/update?header' value = gallery.${gal_key}.gal_name %]
        </h2>
[% PROCESS editable.tpl name='/admin/gallery/' _ gal_key _ '/update?body' value = gallery.${gal_key}.gal_description %]
	<br />
[% IF access.manage_gallery %]
	<script type="text/javascript">
	    var gallery_key = "[% gal_key %]"; 
	    cte_text = '<font color="#AAA"><small>[% t('Click to add new information about gallery') %]</small></font>';
	</script>
	<div class="dropZone"><b>[% t('Drop new images here') %]</b></div>
[% END %]
      <ul id="gallerys" class="gallerys">
[% FOREACH img IN images %]
	    <li>
    [% PROCESS gallery/image.tpl img=img %]
	    </li>
[% END %]
[% IF access.manage_gallery %]
	    <li class='last_li'>
	        <div class="dropZone" style="width:200px;height:200px;"><b>[% t('Drop new images here') %]</b></div>
	    </li>
[% END %]
      </ul>
      <br class="clear" />

[% IF access.manage_gallery %]

<script>
    $(function() {
	$( "#gallerys" ).sortable(
	    { opacity: 0.8, revert: true, 
		start: function(event, ui) { $('.gallery a').unbind(); }, 
		stop:  function(event, ui) { $('.gallery a').lightBox(); }, 
		update: function(event, ui) { 
		    var result = [];
		    $('#gallerys').each(function(){
			$(this).find('li').each(function(){
			    result.push ( $(this).find('a img').attr('id') );
			});
		    });
//		    alert (result.join());
                    save_text( '/admin/gallery/sort/'+result.join(), {}, 'image position saved'); 
		} 
	    });
	$( "#gallerys" ).disableSelection();
    });
</script>

<script type="text/javascript">
    onDelete = function () {
//	if ( confirm ('[% t('Are you sure to delete this image?') %]') ) 
	{
            save_text( '/admin/gallery/delete/'+$(this).attr('name'), {}, 'image was deleted'); 
	    $(this).parent().animate({opacity:0}, 700, function(){ $(this).css({display:"none"}); });
	}
	return false;
    }
    $('.delete').click( onDelete );
</script>
[% END %]

    </div>
</td></tr></table>

<a href="/gallery">&lt;&lt;[% t('back') %]</a>

