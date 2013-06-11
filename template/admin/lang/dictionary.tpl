<h1>[% t('Dictionary') %]</h1>

<select name="languages_dictionary" id="languages_dictionary">
</select>
<script type="text/javascript">
    $(document).ready(function(){
        selectValues = { [% FOREACH l IN config.languages.sort %]"[% l %]" : "[% config.languages_t.${l} %]", [% END %] "": "" };
        $.each(selectValues, function(key, value) {
            if ( key ) {
                $('#languages_dictionary')
                    .append($("<option></option>")
                    .attr("value", key )
                    .text(value)); 
            };
        });
        $("select option[value='[% lang %]']").attr("selected","selected");
        $('#languages_dictionary').change(function(){
	    location = "/admin/lang/dictionary/" + $(this).val();
	});
    });
</script>
<br /><br />


[% FOREACH d IN dictionary.keys.sort %]
[% NEXT UNLESS d %]
<a href="/admin/lang/dictionary/[% lang %]/delete/[% d %]">x</a>
[% d %] => <span id="/admin/lang/dictionary/[% lang %]/edit/[% d %]" class="editable">[% dictionary.${d}.${lang} %]</span>
<br />

[% END %]

