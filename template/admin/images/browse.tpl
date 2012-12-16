<!DOCTYPE html>
<html>
<head>
<title>Image browser</title>
</head>

<body>
<h2>Browse</h2>

    <style>
	figure {
	    background: #d9dabb;
    	    display: block;
    	    width: 130px;
    	    height: 130px;
    	    float: left;
    	    margin: 0 10px 10px 0;
    	    padding: 10px 0 0 0;
    	    text-align: center;
        }
	figure img {
    	    border: 4px solid #8b8e4b;
    	}
    	.delete {
    	    color: #e00;
    	}
    </style>

<article>
[% FOREACH k IN fl %]
<figure>
    <a href="#" onclick="window.opener.CKEDITOR.tools.callFunction([% num %], '/[% k %]');window.close();return false;"><img height="80" width="100" src="/[% k %]"></a>
    <figcaption>
	<a href="#" onclick="window.opener.CKEDITOR.tools.callFunction([% num %], '/[% k %]');window.close();return false;">select</a>
	<a href="/admin/images/delete/[%k%]" class="delete">delete</a>
    </figcaption>
</figure>
[% END %]
</article>

<script type="text/javascript">
    $('.delete').click(function () {
	if ( confirm ('[% t('Are you sure to delete this image?') %]') ) 
		{ location.replace('/admin/gallery/delete/'+$(this).attr('name')) }; 
	return false;
    });
</script>

</body>

</html>