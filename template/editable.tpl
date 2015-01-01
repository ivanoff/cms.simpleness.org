<div id="[% name %]" class="editable [% dont_save? 'dont_save' : '' %]">
[% sources.item(name.replace('^\?','')).content_body || value %]
</div>
