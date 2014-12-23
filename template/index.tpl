<!DOCTYPE html>
<html lang="en-US" [% IF language.search('il|fa|ar') %] dir="rtl" [% END %]>
    <head>
        <title>[% title %]</title>
        <meta charset="utf-8" />
        <meta name="description" content="[% meta.description %]" />
        <meta name="keywords" content="[% meta.keywords %]" />
        <meta name="category" content="[% meta.category %]" />
        <link rel="stylesheet" href="/css/mobile.css" media="screen and (max-width: 600px)" />
        <link rel="stylesheet" href="/css/style.css" media="screen and (min-width: 600px)" />
        <link rel="stylesheet" href="/css/print.css" media="print" />
        <link rel="stylesheet" href="/css/default.css" />
        <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/themes/smoothness/jquery-ui.css" />
        <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>
        <script src="/js/default.js" type="text/javascript"></script>
[% IF access.edit_content -%]
        <link rel="stylesheet" href="/css/default_admin.css" />
        <script type="text/javascript">
            var session = "[% session('_SESSION_ID') %]";
            var lang = "[% language %]";
            var title = "[% title %]"; 
            var page = "?[% env('REDIRECT_URL') %]"; 
            var uri = "[% env('REDIRECT_URL') %]"; 
            var image_sizes = [ 'full size', '[% config_images.SIZE.join("','") %]' ];
        </script>
        <script src="/js/nicEdit.js" type="text/javascript"></script>
        <script src="/js/default_admin.js" type="text/javascript"></script>
[% END -%]
    </head>
    <body>
[% PROCESS panel_edit.tpl %]
    <!-- Shell -->
        <div id="shell">
	<!-- Header -->
	    <div id="header" class="big-box">
		<div class="bg-bottom">

[% PROCESS editable.tpl name='_header'; %]

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
[% BLOCK main_menu     -%]
[%   FOREACH m IN menu -%]
[%     NEXT IF m.menu_parent != level -%]
        <li><a href="[% m.menu_url %]" [% 'class="active"' IF env('REDIRECT_URL') == m.menu_url %]><span>[% m.menu_name %]</span></a>
            <ul>[% INCLUDE main_menu level = m.menu_key -%]</ul>
        </li>
[%     END -%]
[%   END   -%]
[% INCLUDE main_menu level = 0 -%]

[% IF session('slogin') -%]
	<li><a href="/admin" [% 'class="active"' IF env('REDIRECT_URL') == '/admin' %]><span>[% t('Admin page') %]</span></a></li>
	<li><a href="/login/exit"><span>[% t('exit') %]</span></a></li>
[% ELSE -%]
	<li><a href="/login" [% 'class="active"' IF env('REDIRECT_URL') == '/login' %]><span>[% t('login') %]</span></a></li>
	<li><a href="/login/register" [% 'class="active"' IF env('REDIRECT_URL') == '/login/register' %]><span>[% t('Register') %]</span></a></li>
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

[% UNLESS read_only %]
[% PROCESS editable.tpl 
        name=env('REDIRECT_URL') 
        value=(access.edit_content)? content_edit : content; %]
[% END %]

[% body %]

[% IF access.view_addthis; PROCESS panel_addThis.tpl; END %]

</div>


			</div>
		</div>
	</div>
	<!-- /Main -->

	<!-- Footer -->
	<div id="footer">

[% PROCESS editable.tpl name='_bottom'; %]

	<p>
	Created by <a href="http://ivanoff.org.ua" target="_blank">ivanoff</a> / 
	Powered by <a href="http://cms.simpleness.org" target="_blank">Simpleness CMS</a>
	<a href="/login"><img src="/images/btn_key.png" id="admin_key" border="0"></a>
	</p>

	</div>
	<!-- /Footer -->

</div>
<!-- /Shell -->
</body>
</html>