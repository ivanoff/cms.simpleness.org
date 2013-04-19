#!/usr/bin/perl

use strict;
use warnings;

use lib '../modules';
use CONFIG;
use Time::HiRes qw( gettimeofday tv_interval );
use MAIN::Cache qw( cache_load );
use MAIN::Update qw( update need_to_update );

my $time_interval = [ gettimeofday() ];

# get session parameters
our $index_session;
if ( $ENV{HTTP_COOKIE} && $ENV{HTTP_COOKIE} =~ /CGISESSID=([0-9a-f]{32})/ ) {
    $index_session = eval { local $SIG{__DIE__}; do $CONFIG->{session_dir}."/cgisess_$1"; };
}

if ( my $body = cache_load ) {
    # show page from cache
    print "Content-Type: text/html; charset=utf-8\nCache-Control: no-cache, must-revalidate\nExpires: Sat, 26 Jul 1997 05:00:00 GMT\n\n";
    print @$body;
    print "\n<!-- ".(tv_interval($time_interval)*1000)." ms cache $_ -->";
} else {
    # main lifecycle
    require 'main.pl';
}

update if $CONFIG->{update_automatically} && need_to_update;
