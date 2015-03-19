<script>
$(document).ready(function(){
[%   IF hidden %]
    $('.opened_eye#eye-[% key %]').show();
[%   ELSE %]
    $('.closed_eye#eye-[% key %]').show();
[%   END %]
});
</script>

[% IF text; hidden = !hidden; END; %]
<span class="closed_eye" id="eye-[% key %]" style="display:none;">
    <span class="cursor_pointer symbol">[% text? '&#0119;' : '&#0118;' %]</span>
    [% IF text; t('hide news'); END  %]
</span>
<span class="opened_eye" id="eye-[% key %]" style="display:none;">
    <span class="cursor_pointer symbol">[% text? '&#0118;' : '&#0119;' %]</span> 
    [% IF text; t('publish news'); END %]
</span>
