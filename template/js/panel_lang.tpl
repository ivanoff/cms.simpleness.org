<script type="text/javascript">
    $(document).ready(function(){
        selectValues = { [% FOREACH l IN config.languages.sort %]"[% l %]" : "[% config.languages_t.${l} %]", [% END %] "": "" };
        $.each(langValues, function(key, value) {
            if ( key ) {
                $('#languages')
                    .append($("<option></option>")
                    .attr("value", key )
                    .css("background", "url('/images/flags/"+ key +".gif') no-repeat")
                    .css("padding-left", "20px")
                    .text(value)); 
            };
        });
        $("select option[value='"+(( typeof lang === 'undefined' )?  'en' : lang ) +"']").attr("selected","selected");
        $('#languages').change(function(){
	    location = "//" + $(this).val() + "." + site + uri;
	});
    });
</script>
