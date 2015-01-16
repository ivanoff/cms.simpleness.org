<h1>[% t('Change template') %]</h1>

<div style="display: inline-block;" class="gallery">

[% FOREACH t IN templates %]

<figure>
<legend>
<h3><a href="/admin/templates/[% t %]">[% t %]</a></h3>
</legend>
<a href="/admin/templates/[% t %]"><img src="/_templates/[% t %]/example.jpg" align="top" width="200"></a>
</figure>

[% END %]
