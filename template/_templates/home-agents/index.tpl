<!DOCTYPE HTML>
<html>
<head>
<!--
Author: W3layouts
Author URL: http://w3layouts.com
License: Creative Commons Attribution 3.0 Unported
License URL: http://creativecommons.org/licenses/by/3.0/
-->
<title>[% title %]</title>
<link href="/_templates/home-agents/css/style.css" rel="stylesheet" type="text/css" media="all" />
<link rel="stylesheet" href="/css/default.css" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/themes/smoothness/jquery-ui.css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>
[% PROCESS js/variables.tpl %]
        <script src="/js/default.js"></script>
[% IF access.edit_content %]
        <link rel="stylesheet" href="/css/admin/default.css" />
        <script src="/js/admin/default.js"></script>
        <script src="/js/nicEdit.js"></script>
[% END %]
</head>
<body>
[% PROCESS panel_edit.tpl %]
<div class="wrap">
	<div class="wrapper">
	<div class="header">
	<div class="h-top">
		<div class="logo">
[% PROCESS editable.tpl name='?_header'; %]
		</div>
		<div class="header-block">
			<div>
[% IF session('slogin') %]
	<a href="/admin" [% 'class="active"' IF env('REDIRECT_URL') == '/admin' %]><span>[% t('Admin page') %]</span></a>
	<span>|</span> <a href="/login/exit"><span>[% t('Exit') %]</span></a>
[%   IF access.edit_menu %]
        <span>|</span> <a href="/admin/menu"><span class="symbol">&#0063;</span></a>
[%   END %]
[% ELSE %]
	<a href="/login" [% 'class="active"' IF env('REDIRECT_URL') == '/login' %]><span>[% t('Login') %]</span></a>
	<span>|</span> <a href="/login/register" [% 'class="active"' IF env('REDIRECT_URL') == '/login/register' %]><span>[% t('Register') %]</span></a>
[% END %]
[% IF is_demo %]
        <span>|</span> <a href="/login/demo/off">[% t('Demo off') %]</a>
[% END %]
			</div>
			<ul class="social-icons">
				<li><a href="#" class="icon-1"></a></li>
				<li><a href="#" class="icon-2"></a></li>
				<li><a href="#" class="icon-3"></a></li>
			</ul>
		</div>
	<div class="clear"></div>
	</div>
	<div class="menu-main">
	<ul class="dc_css3_menu">
[% BLOCK main_menu     %]
[%   FOREACH m IN menu %]
[%     NEXT IF m.menu_parent != level %]
        <li><a href="[% m.menu_url %]" [% 'class="active"' IF env('REDIRECT_URL') == m.menu_url %]><span>[% m.menu_name %]</span></a>
            <ul>[% INCLUDE main_menu level = m.menu_key %]</ul>
        </li>
[%     END %]
[%   END   %]
[% INCLUDE main_menu level = 0 %]
        </ul>
    <div class="clear"></div>
  </div>
<div class="clear"></div>
</div>
	<div class="content">

[% UNLESS read_only;
     PROCESS editable.tpl 
        name='?' _ env('REDIRECT_URL')
        value=(access.edit_content)? content_edit : content;
   END %]

[% body %]

		<div class="clear"></div>
    </div>	
    </div>
    </div>
    </div>

	  <div class="footer-bot">
	 <div class="wrap">
	 <div class="copy">
[% PROCESS editable.tpl name='?_bottom'; %]
		 <div class="clear"></div>
            <p>
	        Created by <a href="http://ivanoff.org.ua" target="_blank">ivanoff</a> / 
	        Design by <a href="http://w3layouts.com">W3Layouts</a> / 
	        Powered by <a href="http://cms.simpleness.org" target="_blank">Simpleness CMS</a>
	        <a href="/login"><img src="/images/btn_key.png" class="admin_key" border="0"></a>
            </p>
	  </div>
	 </div>
	</div>
</body>
</html>