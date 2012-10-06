<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html lang="en-US" xmlns="http://www.w3.org/1999/xhtml" [% IF direct_rtl %] dir="rtl"[% END %]>
<head>
	<title>[% title %]</title>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8" />
	<meta name="description" content="[% meta.description %]" />
	<meta name="keywords" content="[% meta.keywords %]" />
	<meta name="category" content="[% meta.category %]" />
	<link rel="stylesheet" href="/css/style.css" type="text/css" media="all" />
	<link rel="stylesheet" href="/css/print.css" type="text/css" media="print" />
	<link rel="stylesheet" href="/css/mobile.css" type="text/css" media="only screen and (max-device-width: 640px)" />
	<script type="text/javascript" src="/js/jquery.js"></script>
[% IF image %]
	<link href="/css/lightbox.css" rel="stylesheet" type="text/css" media="screen" />
	<script type="text/javascript" src="/js/lightbox.js"></script>
	<script type="text/javascript">
	    $(function() { $('.gallery a').lightBox(); });
	</script>
[% END %]
[% IF access.can_edit_content %]
	<script type="text/javascript" src="/editor/ckeditor.js"></script>
[% END %]
	<script type="text/javascript">
	    $(document).ready(function(){
		$('#languages').change(function(){
		    location = $(this).val();
		})
	    });
	</script>
</head>
<body>
<!-- Shell -->
<div id="shell">
	<!-- Header -->
	<div id="header" class="big-box">
		<div class="bg-bottom">
[% source='_header' %]
[% IF access.can_edit_content %]
    [% INCLUDE admin/editor.tpl %]
[% ELSE %]
    [% sources.item(source).content_body %]
[% END %]
			<div class="bg-bottom-right">
<select name="languages" id="languages">
    [% FOREACH l IN languages.sort %]
        <option [% 'selected' IF ( language == l || (!language && l =='ru') ) %] value="//[% IF l!=default_language %][% l _ '.' %][% END %][% config.site %][% uri %]" style="background: url(/images/flags/[% l %].gif) no-repeat; padding-left: 20px;">[% languages_t.${l} %]</option>
    [% END %]
</select>
			</div>
			<div class="cl">&nbsp;</div>
		</div>
	</div>
	<!-- /Header -->
	
	<!-- Navigation -->
	<div id="navigation">
		<ul class="dropdown dropdown-horizontal">
			<li><a href="/" [% 'class="active"' IF uri == '' %]><span>[% t('Home') %]</span></a></li>
			<li><a href="/download" [% 'class="active"' IF uri == '/download' %]><span>[% t('Download') %]</span></a></li>
			<li><a href="/to-do_list" [% 'class="active"' IF uri == '/to-do_list' %]><span>[% t('To-do list') %]</span></a></li>
			<li><a href="/news" [% 'class="active"' IF uri == '/news' %]><span>[% t('News') %]</span></a></li>
			<li class="dir"><a href="/gallery" [% 'class="active"' IF uri.match('^/gallery/?') %]><span>[% t('Gallery') %]</span></a>
			    <ul>
[% FOREACH g IN gallery.keys %]
				<li><a href="/gallery/[% gallery.${g}.gal_key %]" [% 'class="active"' IF uri == '/gallery/' _ gallery.${g}.gal_id %]>[% gallery.${g}.gal_name %]</a></li>
[% END %]
			    </ul>
			</li>
			<li><a href="/contacts" [% 'class="active"' IF uri == '/contacts' %]><span>[% t('Contact Us') %]</span></a></li>
[% IF login %]
			<li><a href="/admin" [% 'class="active"' IF uri == '/admin' %]><span>[% t('Admin page') %]</span></a></li>
[% END %]
			
		</ul>
		<div class="cl">&nbsp;</div>
	</div>
	<!-- /Navigation -->
	
	<!-- Main -->
	<div id="main" class="big-box">
		<div class="bg-top">
			<div class="bg-bottom">

[% IF access.print_page %]
<a href="#" id="print_button" onclick="print();return false;"><img src="/images/btn_print.gif" border="0" align="RIGHT"></a>
[% END %]

[% source='' %]
[% IF access.can_edit_content %]
    [% INCLUDE admin/editor.tpl %]
    [% body %]
[% ELSE %]
    [% content %]
    
<!-- AddThis Button BEGIN -->
<div class="addthis_toolbox addthis_default_style " id="no_print">
<br />
<a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
<a class="addthis_button_tweet"></a>
<a class="addthis_button_google_plusone"></a>
<a class="addthis_button_linkedin_counter"></a>
<a class="addthis_counter addthis_pill_style"></a>
</div>
<script type="text/javascript" src="http://s7.addthis.com/js/300/addthis_widget.js#pubid=ra-506ffb3468d2f3c5"></script>
<!-- AddThis Button END -->

    [% body %]
[% END %]


				
			</div>
		</div>
	</div>
	<!-- /Main -->
	
	<!-- Footer -->
	<div id="footer">
[% source='_bottom' %]
[% IF access.can_edit_content %]
    [% INCLUDE admin/editor.tpl %]
[% ELSE %]
    [% sources.item(source).content_body %]
[% END %]
		<p>
			Created by <a href="http://ivanoff.org.ua" target="_blank">ivanoff</a>
		</p>
	</div>
	<!-- /Footer -->
</div>
<!-- /Shell -->
</body>
</html>