<h2>#[% r.${type.url} %]. [% r.${type.district} %] - [% r.${type.street} %]</h2>

<div class="news index">
    <h3>
        [% r.${type.price} %]$ / [% r.${type.size} %] / [% r.${type.header} %]
    </h3>
    <p>
        [% r.${type.description} %]
    </p>
[% IF r.${type.coordinates} %]
[%   ll = r.${type.coordinates}.match('([\d\.]+)') %]
    <h3>
        [% t('map') %]
    </h3>
    <p>
        <a href="http://maps.google.com/?q=[% r.${type.coordinates}.replace( ' ', '' ) %]" target="_blank">view on google maps</a><br />
    </p>
[% END %]
[% IF r.${type.images} %]

<script src="/js/lightbox.js"></script>
<script src="/js/gallery.js"></script>

    <h3>
        [% t('photos') %]
    </h3>
    <div class="gallery">
      <ul id="gallerys" class="gallerys">
[% FOREACH image IN r.${type.images}.split(',') %]
        <li>
	    <a href="/images/gallery/realtor/640x480/[% image %]" title="image_title">
	    <img align="top" src="/images/gallery/realtor/[% config_images.SIZE.0 %]/[% image %]" alt="" id="[% image %]"></a>
	</li>
[% END %]
      </ul>
    </div>
    <br class="x" />
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

