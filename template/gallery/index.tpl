<h1>[% t('Gallery') %]</h1>
[% FOREACH g IN gallery.keys %]
&nbsp; <a href="/gallery/[% gallery.${g}.gal_id %]">[% gallery.${g}.gal_name %]</a><br />
[% END %]

