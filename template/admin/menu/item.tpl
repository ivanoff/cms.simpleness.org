[% FOREACH m IN menu %]
        [% NEXT IF m.menu_parent != level %]
        <li id="[% m.menu_key %]">
        <i class='icon-move'></i>
        <i class='icon-trash' onclick="delete_menu(this);return(false);"></i> 
[% 
#     PROCESS editable.tpl 
#        name=env('REDIRECT_URL') 
#        value=(access.edit_content)? content_edit : content;
%]
        <span id="/admin/menu/edit/[% m.menu_key %]/update?body" class="editable">
            <a href="[% m.menu_url %]">[% m.menu_name %]</a>
        </span>
        <ol>[% INCLUDE 'admin/menu/item.tpl' level=m.menu_key %]</ol></li>
[% END %]
