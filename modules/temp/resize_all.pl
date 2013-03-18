#!/usr/bin/perl

## resizing all large photos

use lib '../../modules';
use CONFIG;
use MAIN;

use strict;
use warnings;

foreach my $dir (<../../www/images/gallery/*>) {
    next unless -d $dir;
    print "$dir directory found\n";
    foreach my $from (<$dir/640x480/*.jpg>, <$dir/640x480/*.JPG>) {
        print "resizing $from\n";
        my $to = $from;
        $to =~ s/640x480/174x174/;
        resize ( $from,  $to , 174, 174 );
    }
}

