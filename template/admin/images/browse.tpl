
    <style>
	figure {
	    background: #d9dabb;
    	    display: block;
    	    width: 100px;
    	    height: 120px;
    	    float: left;
    	    margin: 0 5px 5px 0;
    	    padding: 5px 0 0 0;
    	    text-align: center;
        }
	figure img {
    	    border: 4px solid #8b8e4b;
    	}
    	.delete {
    	    color: #e00;
    	}
    </style>

<select id='size'>
[% FOREACH s IN size %]
    <option value='[% s %]'>[% s %]</option>
[% END %]
    <option value=''>full size</option>
</select>

<article>
[% FOREACH f IN files %]
<figure>
    <a href="#" class="insert" id="[% f %]"><img height="80" width="80" src="/[% path %]/[% size.0 %]/[% f %]"></a>
    <figcaption>
	<a href="#" class="insert" id="[% f %]">select</a>
	<a href="#" class="delete" id="[% f %]">delete</a>
    </figcaption>
</figure>
[% END %]
</article>

<script type="text/javascript">
    $('.insert').click(function () {
	$('#src', window.parent.document).val( '/[% path %]/'+ $('#size option:selected').val() +'/'+ $(this).attr("id") );
	$('input[type="submit"]', window.parent.document).trigger('click');
    });
    $('.delete').click(function () {
	if ( confirm ('[% t('Are you sure to delete this image?') %]') ) { 
            window.parent.save_text( '/admin/images/delete/'+$(this).attr('id'), {}, 'image was deleted'); 
	    $(this).parent().parent().animate({opacity:0}, 700, function(){ $(this).css({display:"none"}); });
	}; 
	return false;
    });
</script>

