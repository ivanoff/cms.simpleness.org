<!DOCTYPE html>
<html>
<head>
<title>[% title %]</title>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="/_templates/ecothunder/css/style.css">
<!--[if IE 9]><link rel="stylesheet" type="text/css" href="/_templates/ecothunder/css/ie9.css"><![endif]-->
<!--[if IE 8]><link rel="stylesheet" type="text/css" href="/_templates/ecothunder/css/ie8.css"><![endif]-->
<!--[if IE 7]><link rel="stylesheet" type="text/css" href="/_templates/ecothunder/css/ie7.css"><![endif]-->
        <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
        <link rel="icon" href="/favicon.ico" type="image/x-icon">
        <link rel="stylesheet" href="/css/default.css" />
        <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/themes/smoothness/jquery-ui.css" />
        <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.2/jquery-ui.min.js"></script>
        <link href='http://fonts.googleapis.com/css?family=Cuprum:400,700&subset=latin,cyrillic' rel='stylesheet' type='text/css'>
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
<div id="header">
  <div>
    <div id="logo">
[% PROCESS editable.tpl name='?_header'; %]
    </div>
    <div id="navigation">
      <div>
        <ul>
[% BLOCK main_menu     %]
[%   FOREACH m IN menu %]
[%     NEXT IF m.menu_parent != level %]
        <li><a href="[% m.menu_url %]" [% 'class="current"' IF env('REDIRECT_URL') == m.menu_url %]>[% m.menu_name %]</a></li>
[%     END %]
[%   END   %]
[% INCLUDE main_menu level = 0 %]
        </ul>
      </div>
    </div>
  </div>
</div>
<div id="content">
<div id="inner">

[% PROCESS editable.tpl name='?_inner_info'; %]
[% IF session('slogin') %]
<div id="admins">
<a href="/admin" [% 'class="active"' IF env('REDIRECT_URL') == '/admin' %]><span>[% t('Admin page') %]</span></a>
 | <a href="/login/exit"><span>[% t('Exit') %]</span></a>
[%   IF access.edit_menu %]
 | <a href="/admin/menu"><span class="symbol">&#0063;</span></a>
[%   END %]
</div>
[% END %]

[% UNLESS read_only;
     PROCESS editable.tpl 
        name='?' _ env('REDIRECT_URL')
        value=(access.edit_content)? content_edit : content;
   END %]

[% body %]

</div>
</div>
<div id="footer">

[% PROCESS editable.tpl name='?_bottom'; %]

<div id="admins">
Created by <a href="http://ivanoff.org.ua" target="_blank">ivanoff</a> /
Website Template By <a target="_blank" href="http://www.freewebsitetemplates.com/">freewebsitetemplates.com</a> /
Powered by <a href="http://cms.simpleness.org" target="_blank">Simpleness CMS</a>
<a href="/login"><img src="/images/btn_key.png" class="admin_key" border="0"></a>
</div>

</div>
</body>
</html>
