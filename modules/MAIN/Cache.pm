#!/usr/bin/perl

package MAIN::Cache;

use strict;
use warnings;

use File::Path qw( make_path );
use Digest::MD5 qw( md5_hex );

our $VERSION = '0.3';
our @ISA     = qw( Exporter );
our @EXPORT  = qw( cache_save cache_delete cache_load );

sub cache_md5_filename {
    md5_hex ( ($ENV{'SERVER_NAME'}||'') . ($ENV{'REQUEST_URI'}||'') );
}

sub cache_dir {
    $main::CONFIG->{cache_dir}.'/'.substr(&cache_md5_filename, 0, 1).'/'.substr(&cache_md5_filename, 0, 2);
}

sub cache_filename {
    &cache_dir . "/" . &cache_md5_filename;
}

sub cache_save {
    return 0 if !$main::CONFIG->{cache};
    return 0 if ( $main::SESSION && $main::SESSION->param('slogin') );
    my $content = shift;
    make_path( &cache_dir ) unless -e &cache_dir;
    open F, '>', &cache_filename;
    print F $content;
    close F;
    utime time+$main::CONFIG->{cache_time}, time+$main::CONFIG->{cache_time}, &cache_filename;
    return 1;
}

sub cache_delete {
    $ENV{'REQUEST_URI'} = shift if @_;
    unlink &cache_filename if -e &cache_filename;
    return 1;
}

sub cache_load {
    return 0 if !$main::CONFIG->{cache}
             || $ENV{'REQUEST_METHOD'} eq 'POST'
             || ( $main::index_session && $main::index_session->{slogin} )
             || !-e &cache_filename
             || (stat(&cache_filename))[9] < time ;

    open F, &cache_filename;
    my @result = <F>;
    close F;
    return \@result;
}

1;
