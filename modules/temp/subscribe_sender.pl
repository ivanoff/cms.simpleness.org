#!/usr/bin/perl

#send message to subscribers

use strict;
use warnings;
use utf8;

use lib '..';
use CONFIG;
use DATABASE;
use MAIN;

#limit messages per single run
my $limit = 10;
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
#        print "good\n";
        $db->sql( "UPDATE base_subscribe_current SET subs_result='sent' WHERE id=?", $_->{id} );
    } else {
#        print "$s\n";
        $db->sql( "UPDATE base_subscribe_current SET subs_result='error', subs_error=? WHERE id=?", $s, $_->{id} );
    }

}


