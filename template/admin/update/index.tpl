<h2>[% t('Update') %]</h2>

[% FOREACH files IN new.keys %]
    [% IF new.${files} != old.${files} %]
        <a href="/admin/update/diff/[% files %]">diff</a> [% files %]<br>
    [% END %]
[% END %]
