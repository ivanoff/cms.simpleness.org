<link href="/css/admin/menu_sort.css" rel="stylesheet">
<script src="/js/admin/menu_sort.js"></script>
<script src="/js/admin/menu.js"></script>

<h1>[% t('Menu') %]</h1>

<h3>[% t('Add new menu') %]</h3>

<input type="text" name="new_menu" value="" id="new_menu" placeholder="[% t('enter new menu name') %]">
<input type="text" name="new_menu_url" value="" id="new_menu_url" placeholder="[% t('URL') %]">
<input type="button" value="[% t('add menu') %]" id="new_menu_button" onclick="add_new_menu();">
<img id="new_menu_img" src="/images/spacer.gif">
<br /><br />

<h3>[% t('Manage menu') %]</h3>

<ol class="default vertical" id="menu">
[% INCLUDE 'admin/menu/item.tpl' level=0 %]
</ol>

