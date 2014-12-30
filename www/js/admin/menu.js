$(function  () {
    $('ol.default').sortable( {

        group: 'no-drop',
        handle: 'i.icon-move',

        onDragStart: function (item, container, _super) {
        // Duplicate items of the no drop area
            if(!container.options.drop)
                item.clone().insertAfter(item)
                _super(item)
        },

        stop: function () {
            var arr = [];
            var keys = [];
            var result = '';

            function a ( t ) {
                t.find('li').each( function() {
                    if( !arr[$(this).attr('id')] ) {
                        keys.push( $(this).attr('id') );
                        arr[$(this).attr('id')] = t.attr('id');
                    }
                    if( $(this).find('ol') ) a( $(this) );
                });
            };

            a( $('#menu') );

            for (var i = 0; i < keys.length; i++) {
                if (arr.hasOwnProperty(keys[i]))
                    result = result + keys[i] + ':' + arr[keys[i]] +';';
            }

            $.ajax({
                type: "GET",
                url: '/admin/menu/sort/'+result,
            });

            show_info( "menu was moved" );
        }
    } );
});

function add_new_menu() {
    $('#new_menu').fadeTo( 200, 0.2 );
    $('#new_menu_url').fadeTo( 200, 0.2 );
    $('#new_menu_button').attr('disabled','disabled').fadeTo( 200, 0.2 );
    $('#new_menu_img').fadeTo( 500, 1 ).attr('src', '/images/lightbox/ico-loading.gif');

    $.ajax({
        type: "GET",
        url: '/admin/menu/add/'+$("#new_menu").val()+'/'+$("#new_menu_url").val(),
        data: ({ issession : 123 }),
        dataType: "xml",
//            async: false,
        success: function(xml) {
            data = '<li id="' + $(xml).find("id").text() + '">';
            data += '<i class="icon-move"></i> ';
            data += '<i class="icon-trash" onclick="delete_menu(this);return(false);"></i> ';
            data += '<span id="/admin/menu/update?body" class="editable"> ';
            data += '<a href="' + $(xml).find("url").text() + '">';
            data += $(xml).find("name").text() + '</a> ';
            data += '</span> ';
            data += '<ol></ol></li>';

            $("#menu").append( data );

            $("#new_menu").val('');
            $("#new_menu_url").val('');
            $('#new_menu').fadeTo( 200, 1 );
            $('#new_menu_url').fadeTo( 200, 0.5 );
            $('#new_menu_button').removeAttr('disabled').fadeTo( 200, 1 );
            $('#new_menu_img').fadeTo( 500, 1 ).attr('src', '/images/spacer.gif');

            myNicEditor.addInstance('/admin/menu/update?body'); 
            show_info( "menu was added" );
        },
    });
}

function delete_menu(a) {
    $(a).closest('li').fadeTo('slow', 0.5);
    $.ajax({
        type: "GET",
        url: '/admin/menu/delete/'+$(a).closest('li').attr('id'),
        dataType: "xml",
//        async: false,
        success: function(data) {
            $(a).closest('li').remove();
        },
    });
    show_info( "menu was deleted" );
}

$(document).ready(function(){
    $('#new_menu_url').fadeTo( 200, 0.5 );
    var menu_url_auto_fill = 1;
    $('#new_menu_url').keypress(function() {
        menu_url_auto_fill = 0;
        $('#new_menu_url').fadeTo( 500, 1 );
    });
    $('#new_menu').keyup(function() {
        if ( menu_url_auto_fill ) {
            var url = $('#new_menu').val().replace( /[\s\/\''\""]/g, '_' );
            $('#new_menu_url').val( '/'+url );
        }
    });
});
