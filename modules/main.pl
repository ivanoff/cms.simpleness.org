#!/usr/bin/perl

use strict;
use warnings;

use Template;
use CGI::Session;

use CONFIG;
use DATABASE;
use TRANSLATE;
use MAIN;

our ( $db, $t, $tt, $template, $SESSION, $header, );

{
    # create SubTemplate package for override 'process' method
    # to add default variables and return output if no outstream variable
    package SubTemplate;
    our @ISA = qw( Template );
    sub process {
        my ($self, $template, $vars, $outstream, @opts) = @_;
        my $output;
        $vars = ($vars)? { %$tt, %$vars } : $tt;
        my $_ = $ENV{'SERVER_NAME'}.'/'.$template;
        $template = $_ if -e $main::CONFIG_TEMPLATE->{INCLUDE_PATH}.'/'.$_;
        my $r = $self->SUPER::process( $template , $vars, ($outstream)?$outstream:\$output, @opts);
        return ($outstream)? $r : $output;
    }
};

my $time_interval = [gettimeofday()];
$ENV{'SERVER_NAME'} =~ s/^www\././;

my $session_id = ( $ENV{HTTP_COOKIE} && $ENV{HTTP_COOKIE} =~ /CGISESSID=([0-9a-f]{32})/ )? $1 : 0;
unless( $session_id ) {
    $SESSION = new CGI::Session("driver:File", undef, {Directory=>$CONFIG->{session_dir}});
    $session_id = $SESSION->id();
}
$SESSION = CGI::Session->load( "driver:File", $session_id, {Directory=>$CONFIG->{session_dir}} );
if ( $SESSION->is_expired || session('_SESSION_ATIME')+13600<time) {
    $SESSION->delete();
    $SESSION->flush();
    $SESSION = new CGI::Session("driver:File", $session_id, {Directory=>$CONFIG->{session_dir}});
    $session_id = $SESSION->id();
}

if ( $SESSION->param('ip') && $SESSION->param('ip') ne $ENV{REMOTE_ADDR} ) {
    $SESSION->delete();
    $SESSION->flush();
}

## Get current language
my $lang = ($ENV{'SERVER_NAME'} =~ /^([a-z]{2})\./i)? $1 : '';
$lang = lang('default') unless grep {$_ eq $lang} @{$CONFIG->{languages}};

$t = TRANSLATE->new($lang);
$db = DATABASE->new;
$template = SubTemplate->new($CONFIG_TEMPLATE);

#fake CGI module
use CGI;
our $q = CGI->new;

## Default variables for Template Toolkit
$tt = {
    env           => sub{ $ENV{(shift)} },
    session       => sub{ $SESSION->param(shift) },
    config        => $CONFIG,
    config_images => $CONFIG_IMAGES,
    t             => sub{ $t->t(shift) },
    language      => $t->{'language'},
    access        => access( $ENV{'REDIRECT_URL'}, $SESSION->param('slogin') ),
};

## exec &begin link in DEFAULT subsection with REDIRECT_URL parameter
module( '&begin', "/DEFAULT.hash", [ $ENV{'REDIRECT_URL'} ] );

my $body;
#-0
if ( $ENV{'SERVER_NAME'} =~ /^(.*)\.$CONFIG->{site}$/i ) {
    eval { $body = module( $1 , "/SUBDOMAIN.hash", [ $ENV{'REDIRECT_URL'} ] ); };
    print $@;
}
eval { $body = module( $ENV{'REDIRECT_URL'} ); } unless $body;
#-100

module( '&end', "/DEFAULT.hash", [ $ENV{'REDIRECT_URL'} ] );

$body = error( 1, $@ ) if $@;
$body = error( 2, $template->error() ) if $template->error();

if ( !$body && !$tt->{content} && !defined $SESSION->param('slogin') ) {
    print "Status: 404 Not Found\n\n";
} elsif ( $header ) {
    ## if there is any information in header - show it
    print $header."\n\n";
    print $body;
} else {
    my $expires_date = cookie_expires(time+$CONFIG->{session_expires});
    my $current_date = cookie_expires(time);
    print <<EOF;
Set-Cookie: CGISESSID=$session_id; domain=$CONFIG->{site}; path=/; expires=$expires_date
Date: $current_date
Pragma: no-cache
Cache-control: private, no-cache, no-store, must-revalidate, max-age=0, pre-check=0, post-check=0
Content-Type: text/html; charset=utf-8

EOF

    my $page=$template->process('index.tpl', { body=>$body, }, );

    if ( $template->error() ) {
        to_log( $template->error() );
        $page = $template->error() if $CONFIG->{show_errors};
    }

    print $page;
    print "\n<!-- ".(tv_interval($time_interval)*1000)." ms -->";

    cache_save ( $page );

}

1;
