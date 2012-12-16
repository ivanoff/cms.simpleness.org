#!/usr/bin/perl

#update CMS from GIT

our $VERSION = '0.4';

use strict;
use warnings;

use lib '..';
use CONFIG;
use DATABASE;
use MAIN;

use Git::Repository;

=c
my $db = DATABASE->new;

my $r = $db->sql( "SELECT * FROM base_subscribe_current WHERE subs_date<=NOW() AND subs_result='wait' ORDER BY subs_date LIMIT ?", $limit );
foreach ( @$r ) {

    my $email = $db->sql( "SELECT * FROM customers WHERE cust_id=?", $_->{user_id} );

    my $s = email ( { 
	From    => $CONFIG->{email},
    	To    => $email->[0]{cust_email},
	Subject => $_->{subs_subj},
	Message => $_->{subs_body},
    } ); 

    if ( $s eq '1' ) {
#	print "good\n";
	$db->sql( "UPDATE base_subscribe_current SET subs_result='sent' WHERE id=?", $_->{id} );
    } else {
#	print "$s\n";
	$db->sql( "UPDATE base_subscribe_current SET subs_result='error', subs_error=? WHERE id=?", $s, $_->{id} );
    }

}

