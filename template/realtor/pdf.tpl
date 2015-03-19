<h1>№[% data('url', 'pdf') %]. [% data('district', 'pdf') %] - [% data('street', 'pdf') %]</h1>

<h2>
[% INCLUDE realtor/sub_header.tpl %]
</h2>

[% FOREACH h IN header %]
[% NEXT IF h.pdf_hide || !r.${h.column_id} %]
<b>[% h.name %]</b>: [% r.${h.column_id} %] [% h.dimension %]<br />
[% END %]

[% IF data('images') %]
<h3>[% t('photos') %]</h3>
[% FOREACH image IN data('images').split(',') %]
<img width="320" valign="top" src="http://[% config.site %]/images/gallery/realtor/640x480/[% image.replace( ' ', '' ) %]"> &nbsp;
[% END %]
[% END %]
