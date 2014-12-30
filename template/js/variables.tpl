<script type="text/javascript">
    var session = "[% session('_SESSION_ID') %]";
    var lang = "[% language %]";
    var title = "[% title %]"; 
    var page = "?[% env('REDIRECT_URL') %]"; 
    var uri = "[% env('REDIRECT_URL') %]"; 
    var site = "[% config.site %]"; 
    var image_sizes = [ 'full size', '[% config_images.SIZE.join("','") %]' ];
    langValues = { [% FOREACH l IN config.languages.sort %]"[% l %]" : "[% config.languages_t.${l} %]", [% END %] "": "" };
</script>
