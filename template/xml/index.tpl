<?xml version="1.0" encoding="UTF-8"?>
[% FOREACH key IN records.keys %]
<[% key %]>[% records.${key}
    .replace('&','&amp;')
    .replace('<','&lt;')
    .replace('>','&gt;')
    .replace("'",'&apos;')
    .replace('"','&quot;')
    %]</[% key %]>
[% END %]