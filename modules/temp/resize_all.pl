#!/usr/bin/perl

## resizing all large photos

use lib '../../modules';
use CONFIG;
use MAIN;

use strict;
use warnings;

foreach my $dir (<../../images/gallery/*>) {
    foreach (<$dir/640x480/*.jpg>) {
	resize ( $_, s/640x480/174x174/ && $_ , 174, 174 );
    }
}

