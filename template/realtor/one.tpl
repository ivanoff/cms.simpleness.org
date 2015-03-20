
<br /><a href="/realtor?district=[% data('district') %]#[% data('url') %]"> &lt;&lt; [% t('back to the list') %] [% data('district') %]</a> // <a href="/realtor#[% data('url') %]"> &lt;&lt; [% t('back to the full list') %]</a><br />

<a href="#" onclick="print();return false;"><img src="/images/btn_print.gif" border="0" align="right"></a>
<a href="[% data('url') %].pdf"><img src="/images/btn_pdf.gif" border="0" align="right"></a>

<h2>№[% data('url') %]. [% data('district') %] - [% data('street') %]</h2>

<div class="news index">
    <h3>
[% INCLUDE realtor/sub_header.tpl %]
    </h3>
    <p>
        [% data('description') %]
    </p>
[% IF data('coordinates') %]
[%   ll = data('coordinates').match('([\d\.]+)') %]
    <h3>
        [% t('map') %]
    </h3>
    <p>
        <a href="http://maps.google.com/?q=[% data('coordinates').replace( ' ', '' ) %]" target="_blank">view on google maps</a><br />
    </p>
[% END %]
[% IF data('images') %]

<script src="/js/lightbox.js"></script>
<script src="/js/gallery.js"></script>
[% IF access.manage_gallery %]
    <script src="/js/admin/realtor.js"></script>
[% END %]

    <h3>
        [% t('photos') %]
    </h3>
    <div class="gallery">
      <ul id="gallerys" class="gallerys">
[% i = 0 %]
[% FOREACH image IN data('images').split(',') %]
[% image = image.replace( ' ', '' ) %]
[% i = i + 1 %]
        <li>
[% IF access.manage_gallery %]
        <div class="ear" style="width:100px">
        <span class='rotate_image cursor_pointer symbol' name="realtor/[% image %]" id="[% i %]">&#169;</span>
        <span class='unrotate_image cursor_pointer symbol' name="realtor/[% image %]" id="[% i %]">&#170;</span>
        </div>
[% END %]
            <a href="/images/gallery/realtor/640x480/[% image %]" title="image_title">
            <img align="top" src="/images/gallery/realtor/[% config_images.SIZE.0 %]/[% image %]" alt="" id="i[% i %]"></a>
        </li>
[% END %]
      </ul>
    </div>
    <br class="x" />
[% END %]
[% IF data('video') %]
[% hash = data('video').match('v=(\w+)') %]
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
        [% t('Details') %]
    </h4>
    </div>

<ul>
[% FOREACH h IN header %]
[% NEXT IF h.details_hide || !r.${h.column_id} %]
    <li>
 <b>[% h.name %]</b>: [% r.${h.column_id} %] [% h.dimension %]
    </li>
[% END %]
</ul>

</div>

<a href="/realtor#[% data('url') %]"> &lt;&lt; [% t('back') %]</a><br />
<a href="[% data('url') %].pdf"><img src="/images/btn_pdf.gif" border="0"></a>
<a href="#" onclick="print();return false;"><img src="/images/btn_print.gif" border="0"></a>
