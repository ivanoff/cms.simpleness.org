<h1>[% t('Gallery') %]</h1>
<table><tr><td>
    <div class="gallery">
      <h2>[% gallery.${gal_key}.gal_name %]</h2>
	[% gallery.${gal_key}.gal_description %]
	<br /><br />
      <ul>
[% FOREACH img IN images %]
	    <li>
		<a href="/[% img.replace('174x174','640x480') %]" title="Image [% n = n + 1 %][% n %]. [% t('Gallery') %]">
		<img src="/[% img %]" alt="">
		</a>
	    </li>
[% END %]
      </ul>
      <br class="clear" />
    </div>
</td></tr></table>
<a href="/gallery">&lt;&lt;[% t('back') %]</a>

