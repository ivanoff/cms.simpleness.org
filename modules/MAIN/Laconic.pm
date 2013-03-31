#!/usr/bin/perl

package MAIN::Laconic;

use strict;
use warnings;

our $VERSION = '0.2';
our @ISA     = qw( Exporter );
our @EXPORT  = qw(
                params title header
                ban forbid
                process
                sql
                lang
                cache
            );


sub params {
    $main::tt = { %{$main::tt}, %{$_[0]}, };
}

sub title {
    params { title => $_[0] };
}

sub header {
    $_ = shift;
    /xml/ && do {$main::header = "Content-type: text/xml"};
    /gif/ && do {$main::header = "Content-type: image/gif"};
}

sub ban {
    return ( $main::tt->{access}{$_[0]} )? 0 : "permission denied";
}

sub forbid {
    ban (@_);
}

sub process {
    return $main::template->process( @_ );
}

sub sql {
    return $main::db->sql( @_ );
}

sub lang {
    return $main::t->{'language'};
}

sub cache {
    my $cache_time = shift;
    $main::CONFIG->{cache} = ($cache_time)? 1 : 0;
    $main::CONFIG->{cache_time} = $cache_time if $cache_time>1;
}

1;
