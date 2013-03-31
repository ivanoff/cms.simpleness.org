<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
[% FOREACH p IN pages %]
<url>
    <loc>[% p.replace('admin.ship','ship.org.ua') %]</loc>
    <changefreq>monthly</changefreq>
    <priority>[% priority(p) %]</priority>
</url>
[% END %]
</urlset>

