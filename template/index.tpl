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
	<link href="/css/gallery.css" rel="stylesheet" type="text/css" media="screen" />
	<script type="text/javascript" src="/js/lightbox.js"></script>
	<script type="text/javascript">
	    $(function() { $('.gallery a').lightBox(); });
	</script>
[% END %]
[% IF access.edit_content %]
	<link rel="stylesheet" href="/css/admin.css" type="text/css" media="all" />

	<script type="text/javascript">
	    $(document).ready(function(){
	        var cte_text = '<font color="#AAA"><small>click to edit</small></font>';
	        $(".editable").each(function(){ 
	            if ( $(this).text().replace(/(\n|\r|\s)+$/, '') == "" ) {
	                $(this).html( cte_text );
	                $(this).live('click', function () {
	                    if( $(this).html() == cte_text ){
	                        $(this).html("<br>");
	                    };
		        });
	            }
	        });
	    });
	</script>

	<script type="text/javascript">
	    var session = "[% session('_SESSION_ID') %]";
	    var lang = "[% language %]";
	    var title = "[% title %]"; 
	    var page = "?[% uri %]"; 
	    var uri = "[% uri %]"; 
	    var image_sizes = [ 'full size', '[% config_images.SIZE.join("','") %]' ];
	</script>
	<script src="/js/nicEdit.js" type="text/javascript"></script>
	<script src="/js/nicEditRun.js" type="text/javascript"></script>
	<link rel="stylesheet" href="/css/dropBox.css" type="text/css" media="all" />

        <script src="/js/jquery-ui.js"></script>
[% END %]
</head>
<body>
[% PROCESS panel_edit.tpl %]
<!-- Shell -->
<div id="shell">
	<!-- Header -->
	<div id="header" class="big-box">
		<div class="bg-bottom">

<div id="?_header" class="editable">
[% sources.item('_header').content_body %]
</div>

<div class="bg-bottom-right">
[% PROCESS panel_lang.tpl %]
</div>

			<div class="cl">&nbsp;</div>
		</div>
	</div>
	<!-- /Header -->
	
	<!-- Navigation -->
	<div id="navigation">
		<ul class="dropdown dropdown-horizontal">

[% BLOCK main_menu %]
    [% FOREACH m IN menu %]
        [% NEXT IF m.menu_parent != level %]
        <li><a href="[% m.menu_url %]" [% 'class="active"' IF uri == m.menu_url %]><span>[% m.menu_name %]</span></a>
            <ul>[% INCLUDE main_menu level = m.menu_key %]</ul>
        </li>
    [% END %]
[% END %]
[% INCLUDE main_menu level = 0 %]

[% IF session('slogin') %]
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

[% UNLESS templates_only %]
<div id="?[% uri %]" class="editable">
[% (access.edit_content)? content_edit : content %]
</div>
[% END %]

[% body %]

[% IF access.view_addthis %]
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
[% END %]

</div>


				
			</div>
		</div>
	</div>
	<!-- /Main -->
	
	<!-- Footer -->
	<div id="footer">

<div id="?_bottom" class="editable">
[% sources.item('_bottom').content_body %]
</div>

	<p>
	Created by <a href="http://ivanoff.org.ua" target="_blank">ivanoff</a>

	<a href="/login"><img src="/images/btn_key.png" id="admin_key" border="0"></a>
	<script type="text/javascript">
	    $("#admin_key").css({ opacity: 0.1 })
		.mouseover( function(){ $(this).stop().animate({opacity:'1.0'},300); })
		.mouseout ( function(){ $(this).stop().animate({opacity:'0.1'},300); });
	</script>

	</p>

	</div>
	<!-- /Footer -->
</div>
<!-- /Shell -->
</body>
</html>