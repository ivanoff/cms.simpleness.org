[% IF access.realtor_import %]
    <span class="symbol">&#0066;</span> <a href="/admin/realtor/config">[% t('header manager') %]</a> |
    <span class="symbol">&#0042;</span> <a href="/admin/realtor/import">[% t('import file') %]</a><br /><br />
[% END %]

[% IF district %]
[% IF dis %]
<br /><a href="/realtor"> &lt;&lt; [% t('back to the full list') %]</a><br />
[% END %]
[% t('filter by district') %]:
<select name="filter_district" onchange="window.location = '?district='+this.value;">
    <option [% 'selected' UNLESS dis %] value="">[% t('all districts') %]</option>
[% FOREACH d IN district %]
    <option [% 'selected' IF dis == d.g %] value="[% d.g %]">[% d.g %]</option>
[% END %]
</select>
[% END %]

[% FOREACH r IN realtor %]

<div class="news index">
    <a name="[% data( r, 'url' ) %]"></a>
    <div class="date">
    <h4>
        №[% data( r, 'url' ) %]
        <a href="/realtor/[% data( r, 'url') %]">[% data( r, 'district') %] - [% data( r, 'street') %]</a>
        &nbsp;
        [% IF data( r, 'coordinates')  %] <span class='symbol' alt="[% t('video') %]">&#0117;</span> [% END %]
        [% IF data( r, 'images') %] <span class='symbol' alt="[% t('photos') %]">&#0097;</span> [% END %]
        [% IF data( r, 'video')  %] <span class='symbol' alt="[% t('video') %]">&#0099;</span> [% END %]
    </h4>
    </div>
[% FOREACH image IN data( r, 'images').split(',').0 %]
    <a href="/realtor/[% data( r, 'url') %]"><img align="right" width="120" src="/images/gallery/realtor/[% config_images.SIZE.0 %]/[% image %]" style="padding:4px; border:1px solid #AAA;"></a>
[% END %]
    <h3>
[%
    sub_header = [];
    FOREACH k IN [ 'price', 'price_RU', 'size', 'header' ];
        sub_header.push( data( r, k ) ) IF data( r, k );
    END;
    sub_header.join(' / ');
%]
    </h3>
    <p>
        [% info = data( r, 'description').match('((.*?\. ){3})') %]
        [% info.0 ? info.0 _ '...' : data( r, 'description') %]
    </p>
    <p>
        <a href="/realtor/[% data( r, 'url') %]"><small>[% t('read more') %]…</small></a>
    </p>
    <br class="x" />
</div>
[% END %]
