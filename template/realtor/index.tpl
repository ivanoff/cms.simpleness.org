<h2>[% t('Realtor') %]</h2>

[% FOREACH r IN realtor %]
[%# NEXT IF n.news_hidden && !access.add_news %]

<div class="news index">
    <div class="date">
    <h4>
        
        #[% r.${type.url} %]. 
        <a href="/realtor/[% r.${type.url} %]">[% r.${type.district} %] - [% r.${type.street} %]</a>
        &nbsp;
        [% IF r.${type.coordinates}  %] <i class='icon-globe' alt="[% t('video') %]"></i> [% END %]
        [% IF r.${type.images} %] <i class='icon-camera' alt="[% t('photos') %]"></i> [% END %]
        [% IF r.${type.video}  %] <i class='icon-facetime-video' alt="[% t('video') %]"></i> [% END %]
    </h4>
    </div>
    <h3>
        [% r.${type.price} %]$ / [% r.${type.size} %] / [% r.${type.header} %] 
    </h3>
    <p>
        [% info = r.${type.description}.match('((.*?\. ){3})') %]
        [% info.0 ? info.0 _ '...' : r.${type.description} %]
    </p>
    <p>
        <a href="/realtor/[% r.${type.url} %]"><small>[% t('read more') %]…</small></a>
    </p>
</div>
[% END %]
