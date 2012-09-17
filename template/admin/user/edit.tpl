<h2>Edit user</h2>
<a href="/u[% customer.cust_id %]">u[% customer.cust_id %]</a>
<form method="post" enctype="multipart/form-data">

<table>
    <tr>
	<th>
	    email
        </th>
	<td>
	    <input type="hidden" name="cust_id" value="[% customer.cust_id %]">
	    <input type="text" name="cust_email" value="[% customer.cust_email %]">
        </td>
    </tr>
    <tr>
	<th>
	    [% t('customer name') %]
        </th>
	<td>
	    <input type="text" name="cust_name" value="[% customer.cust_name || customer.cust_new_name %]">
	    short:<input type="text" name="cust_name_short" value="[% user.user_name || customer.cust_new_name %]">
        </td>
    </tr>
    <tr>
	<th>
	    [% t('customer phones') %]
        </th>
	<td>
	    <span style="display:none;"><textarea id="phonediv"></textarea></span>
	    <input type="text" name="cust_phones" id="cust_phones" value="[% customer.cust_phones %]">
<!--
		onBlur="if(document.getElementById('phonediv').value){return false;}; 
		    ask('/admin/parse_phone/'+this.value, 'phonediv', false);
		    document.getElementById('cust_phones').value=document.getElementById('phonediv').value;
		    ask('/admin/parse_phone_country/'+this.value, 'phonecountrydiv', false);
		    document.getElementById('cust_country').value=document.getElementById('phonecountrydiv').value;
		    "-->
        </td>
    </tr>
    <tr>
	<th>
	    [% t('customer fax') %]
        </th>
	<td>
	    <input type="text" name="cust_fax" value="[% customer.cust_fax %]">
        </td>
    </tr>
    <tr>
	<th>
	    customer country
        </th>
	<td>
	    <span style="display:none;"><textarea id="phonecountrydiv"></textarea></span>
	    <input type="text" name="cust_country" id="cust_country" value="[% customer.cust_country %]">
        </td>
    </tr>
    <tr>
	<th>
	    customer city
        </th>
	<td>
	    <input type="text" name="cust_city" value="[% customer.cust_city %]">
        </td>
    </tr>
    <tr>
	<th>
	    customer address
        </th>
	<td>
	    <input type="text" name="cust_address" value="[% customer.cust_address %]">
        </td>
    </tr>
    <tr>
	<th>
	    company name
        </th>
	<td>
	    <input type="text" name="cust_company_name" value="[% customer.cust_company_name %]">
        </td>
    </tr>
    <tr>
	<th>
	    web-site
        </th>
	<td>
	    <input type="text" name="cust_url" value="[% customer.cust_url %]">
        </td>
    </tr>
    <tr>
	<th>
	    skype
        </th>
	<td>
	    <input type="text" name="cust_skype" value="[% customer.cust_skype %]">
        </td>
    </tr>
    <tr>
	<th>
	    icq
        </th>
	<td>
	    <input type="text" name="cust_icq" value="[% customer.cust_icq %]">
        </td>
    </tr>
    <tr>
	<th>
	    comment
        </th>
	<td>
	    <input type="text" name="cust_comment" value="[% customer.cust_comment %]">
        </td>
    </tr>
    <tr>
	<th>
	    customer type
        </th>
	<td>
	    <select name="cust_type">
	    [% FOREACH type IN [ '', 'owner', 'broker', 'banned', 'bad email' ] %]
		<option name="[% type %]" [% 'selected="selected"' IF type == customer.cust_type %]>[% type %]</option>
	    [% END %]
	    </select>
        </td>
    </tr>
    <tr><th>&nbsp;</th><td><input type="submit"></td></tr>
</table>

</form>
