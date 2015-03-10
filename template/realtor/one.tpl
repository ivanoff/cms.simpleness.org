<h2>#[% r.${type.url} %]. [% r.${type.district} %] - [% r.${type.street} %]</h2>

<div class="news index">
    <h3>
        [% r.${type.price} %]$ / [% r.${type.size} %] / [% r.${type.header} %]
    </h3>
    <p>
        [% r.${type.description} %]
    </p>
[% IF r.${type.images} %]
    <h3>
        [% t('photos') %]
    </h3>
    <p>
        [% FOREACH image IN r.${type.images}.split(',') %]
        <img src="[% image %]" width="200">
        [% END %]
    </p>
[% END %]
[% IF r.${type.video} %]
[% hash = r.${type.video}.match('v=(\w+)') %]
    <h3>
        [% t('video') %]
    </h3>
    <p>
        <iframe width="420" height="315" src="https://www.youtube.com/embed/[% hash.0 %]" frameborder="0" allowfullscreen></iframe>
    </p>
[% END %]
[% IF r.${type.coordinates} %]
[% ll = r.${type.coordinates}.match('([\d\.]+)') %]
    <h3>
        [% t('map') %]
    </h3>
    <p>
        <a href="http://maps.google.com/?q=[% r.${type.coordinates}.replace( ' ', '' ) %]" target="_blank">view on google maps</a><br />
    </p>
[% END %]

    <br />
    <div class="date">
    <h4>
        [% t('Full information') %]
    </h4>
    </div>
[% FOREACH h IN header %]
[% NEXT UNLESS r.${h.column_id} %]
    <p>
<b>- [% h.name %]</b>: &nbsp; [% r.${h.column_id} %]
    </p>
[% END %]

</div>

