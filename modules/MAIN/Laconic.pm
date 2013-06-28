package MAIN::Laconic;

use strict;
use warnings;

our $VERSION = '0.2';
our @ISA     = qw( Exporter );
our @EXPORT  = qw(
                defaults title header
                ban you_cannot you_can_not
                process
                sql
                t lang is_default_lang
                cache
                param
                session
                images
            );


sub defaults {
    $main::tt = { %{$main::tt}, %{$_[0]}, };
}

sub title {
    defaults { title => $_[0] };
}

sub header {
    my ( $_, $params ) = @_;
    $params->{charset} ||= 'utf-8';
    /html|clear/ && do {$main::header = "Content-type: text/html; charset=$params->{charset};"};
    /xml/ && do {$main::header = "Content-type: text/xml; charset=$params->{charset};"};
    /json/ && do {$main::header = "Content-type: application/json; charset=$params->{charset};"};
    /gif/ && do {$main::header = "Content-type: image/gif;"};
    if ( $params->{no_cache} ) {
        $main::header .= "\nCache-Control: no-cache, must-revalidate\nExpires: Sat, 26 Jul 1997 05:00:00 GMT;";
    }
}

sub ban {
    return ( $main::tt->{access}{$_[0]} )? 0 : "permission denied";
}

sub you_cannot {
    ban(@_)
}

sub you_can_not {
    ban(@_)
}

sub process {
    return $main::template->process( @_ );
}

sub sql {
    return $main::db->sql( @_ );
}

sub t {
    $main::t->t( @_ );
}

sub lang {
    return $main::CONFIG->{default_language} if @_ && $_[0] =~ /^default$/i;
    return $main::t->{'language'};
}

sub is_default_lang {
    my $lang = shift || lang;
    return $lang eq lang('default');
}

sub cache {
    my $cache_time = shift;
    $main::CONFIG->{cache} = ($cache_time)? 1 : 0;
    $main::CONFIG->{cache_time} = $cache_time if $cache_time>1;
}

sub param {
    return $main::q->Vars unless @_;
    return $main::q->param( $_[0] ) unless $_[1];
    return map { $main::q->param( $_ ) } @_;
}

sub session {
    return $main::SESSION->param( @_ ) if @_;
    $main::SESSION->delete();
    $main::SESSION->flush();
    return 1;
}

sub images {
    return $main::CONFIG_IMAGES->{$_[0]} if @_;
}

1;
