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
    <i class="icon-eye-[% text? 'close' : 'open' %]"></i> 
    [% IF text; t('hide news'); END  %]
</span>
<span class="opened_eye" id="eye-[% key %]" style="display:none;">
    <i class="icon-eye-[% text? 'open' : 'close' %]"></i> 
    [% IF text; t('publish news'); END %]
</span>
