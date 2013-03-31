<h2>[% t('Settings') %]</h2>

<div id="contact_form">

<form method="post" name="sett" id="sett">

[% IF access.edit_users %]
[% t('Show only') %]: 
<select name="country">
	<option [% UNLESS session('country') %]selected="selected"[% END %] value='all'>[% t('All') %]</option>
    [% FOREACH c IN country %]
	<option [% IF c.cust_country == session('country') %]selected="selected"[% END %] value='[% c.cust_country %]'>[% c.cust_country %]</option>
    [% END %]
</select>
<br />
[% END %]

[% IF access.subscribe %]
    [% t('Get suitable offers by email') %]: 
    <input type="checkbox" name="subscribe" [% IF session('subscribe') %]checked="checked"[% END %] value="1">
    <br />
[% END %]

[% IF access.relation %]

[% t('Show the best from relevant') %]: 
<input type="radio" [% IF session('show_relevant_best') == 'yes' %]checked="checked"[% END %] name="show_relevant_best" value="yes">[% t('Yes') %]
<input type="radio" [% IF session('show_relevant_best') == 'no' %]checked="checked"[% END %] name="show_relevant_best" value="no">[% t('No') %]
<br />

[% t('Show all relevant') %]: 
<input type="radio" [% IF session('show_relevant') == 'yes' %]checked="checked"[% END %] name="show_relevant" value="yes">[% t('Yes') %]
<input type="radio" [% IF session('show_relevant') == 'no' %]checked="checked"[% END %] name="show_relevant" value="no">[% t('No') %]
<br />

[% t('Show a negative rating') %]: 
<input type="radio" [% IF session('show_unrelevant') == 'yes' %]checked="checked"[% END %] name="show_unrelevant" value="yes">[% t('Yes') %]
<input type="radio" [% IF session('show_unrelevant') == 'no' %]checked="checked"[% END %] name="show_unrelevant" value="no">[% t('No') %]
<br />

[% END %]

[% IF access.show_interests %]
[% END %]

[% IF access.email_page %]
<b>[% t('Mail') %]</b><br />
On page: 
<input type="radio" [% IF session('mail_on_page') == '20' %]checked="checked"[% END %] name="mail_on_page" value="">20
<input type="radio" [% IF session('mail_on_page') == '50' %]checked="checked"[% END %] name="mail_on_page" value="50">50
<input type="radio" [% IF session('mail_on_page') == '100' %]checked="checked"[% END %] name="mail_on_page" value="100">100
<input type="radio" [% IF session('mail_on_page') == 'all' %]checked="checked"[% END %] name="mail_on_page" value="all">all
<br />
[% t('Show only buy and sell') %]:
<input type="radio" [% IF session('mail_show_buy_sell') == 'yes' %]checked="checked"[% END %] name="mail_show_buy_sell" value="yes">[% t('Yes') %]
<input type="radio" [% IF session('mail_show_buy_sell') == 'no' %]checked="checked"[% END %] name="mail_show_buy_sell" value="no">[% t('No') %]
<br />
[% t('Signature') %]:<br />
<textarea cols="45" rows="3" name="mail_singature">[% session('mail_singature') %]</textarea>
<br />
[% END %]

<br />
<input style="font-weight: bold;" type="submit" value='[% t('Submit') %]' name="submit" />
<input type="hidden" name="default" id="default">
<input style="font-weight: bold;" type="submit" value="[% t('Set default') %]" name="submit" onclick="document.getElementById('default').value='1';" />

</form>

</div>