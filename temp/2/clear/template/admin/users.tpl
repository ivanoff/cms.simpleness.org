<h2>[% t('users') %]</h2>

<div>
<form method="post">

[% t( 'user\'s name' ) %]: <br /><input type="text" name="name" value="[% user.0.user_name %]" /><br />
[% t( 'user\'s login' ) %]: <br /><input type="text" name="login" value="[% user.0.user_login %]" /><br />
[% t( 'user\'s password' ) %]: <br /><input type="text" name="password" value="" /><br />
[% t( 'user\'s email' ) %]: <br /><input type="text" name="email" value="[% user.0.user_email %]" /><br />
[% t( 'user\'s group' ) %]: <br />
<select name="group" id="group">
    <option value='0'>default</option>
[% FOREACH r IN rules %]
    <option [%IF r.acc_id == user.0.acc_id %]selected[%END%] value='[% r.acc_id %]'>[% r.acc_name %]</option>
[% END %]
</select>

<br />
<input style="font-weight: bold;" type="submit" name="submit" />

</form>
</div>

<div>
<table>
<tr>
    <th></th>
    <th></th>
    <th></th>
    <th>[% t( 'user\'s name' ) %]</th>
    <th>[% t( 'user\'s login' ) %]</th>
    <th>[% t( 'user\'s password' ) %]</th>
    <th>[% t( 'user\'s email' ) %]</th>
    <th>[% t( 'user\'s group' ) %]</th>
</tr>
[% FOREACH u IN users %]
<tr>
    <td><a href='/admin/users/[% u.user_id %]'>edit</a></td>
    <td><a href='/admin/users/delete/[% u.user_id %]'>delete</a></td>
    <td>[% u.user_id %]</td>
    <td>[% u.user_name %]</td>
    <td>[% u.user_login %]</td>
    <td>[% u.user_password %]</td>
    <td>[% u.user_email %]</td>
</tr>
[% END %]
</table>
</div>
