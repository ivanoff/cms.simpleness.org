<h1>[% t('Gallery') %]</h1>
[% IF access.manage_gallery -%]
    <script type="text/javascript">
        cte_text = '<font color="#AAA"><small>[% t('Click to add new information about gallery') %]</small></font>';
    </script>
[% END %]

<table>
<tr><td>
        <h2>
[% PROCESS editable.tpl name='/admin/gallery/' _ gal_key _ '/update?header' value = gallery.${gal_key}.gal_name %]
        </h2>
[% PROCESS editable.tpl name='/admin/gallery/' _ gal_key _ '/update?body' value = gallery.${gal_key}.gal_description %]
	<br />

[% PROCESS gallery/images.tpl images=images upload_id=gal_key %]

</td></tr>
</table>

<a href="/gallery">&lt;&lt;[% t('back') %]</a>

