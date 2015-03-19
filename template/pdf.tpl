<!DOCTYPE html>
<html>
<head>
<title>[% title %]</title>
<meta charset="UTF-8">
</head>
<body>

<div id="header">
[% PROCESS editable.tpl name='?_header'; %]
[% PROCESS editable.tpl name='?_inner_info'; %]
</div>

<div id="content">
[% PROCESS editable.tpl name='?' _ env('REDIRECT_URL') value = content; %]
[% body %]
</div>

<div id="footer">
[% PROCESS editable.tpl name='?_bottom'; %]
Powered by <a href="http://cms.simpleness.org" target="_blank">Simpleness CMS</a>
</div>

</body>
</html>
