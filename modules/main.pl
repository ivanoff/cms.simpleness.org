#!/usr/bin/perl

use strict;
use warnings;
use lib '../modules';

use DBI;
use Template;

use CGI;
use CGI::Session;

use CONFIG;
use DATABASE;
use TRANSLATE;
use MAIN qw( :all );

our ( $db, $q, $t, $tt, $template, $SESSION, $header, );

{
    # create SubTemplate package for override 'process' method
    # to add default variables and return output if no outstream variable
    package SubTemplate;
    our @ISA = qw( Template );
    sub process {
        my ($self, $template, $vars, $outstream, @opts) = @_;
        my $output;
        $vars = ($vars)? { %$tt, %$vars } : $tt;
        my $r = $self->SUPER::process($template, $vars, ($outstream)?$outstream:\$output, @opts);
        return ($outstream)? $r : $output;
    }
};

my $time_interval = [gettimeofday()];

$q = new CGI;
$SESSION = new CGI::Session("driver:File", undef, {Directory=>$CONFIG->{session_dir}});
if($q->param('_SESSION_ID')) {
    $SESSION = CGI::Session->load( "driver:File", $q->param('_SESSION_ID'), {Directory=>$CONFIG->{session_dir}} );
    if ( $SESSION->is_expired ) {
        $SESSION->delete();
        $SESSION->flush();
    }
}
if ( $SESSION->param('ip') && $SESSION->param('ip') ne $ENV{REMOTE_ADDR} ) {
    $SESSION->delete();
    $SESSION->flush();
}

#-250

## Get current language
$ENV{'SERVER_NAME'} =~ /^(?:www\.)?(?:(\w\w)\.)?/;
my $lang = $1 || $CONFIG->{default_language};
unless ( grep {$_ eq $lang} @{$CONFIG->{languages}} ) {
    print "Status: 404 Not Found\n\n";
    exit 0;
}

$t = TRANSLATE->new($lang);
$db = DATABASE->new;
#-50
$template = SubTemplate->new($CONFIG_TEMPLATE);
#-50

## Default variables for Template Toolkit
$tt = {
    v            => {$q->Vars},
    uri          => $ENV{'REDIRECT_URL'},
    referer      => $ENV{'HTTP_REFERER'},
    session      => sub { $_=shift; $SESSION->param($_) },
    config       => $CONFIG,
    config_images => $CONFIG_IMAGES,
    t            => sub{ $_=shift; return $t->t($_); },
    language     => $t->{'language'},
    direct_rtl   => sub{ $t->{'language'} =~ /(il|fa|ar)/ },
    access       => access( $ENV{'REDIRECT_URL'}, $SESSION->param('slogin') ),
    current_date => sub{ my @d = localtime(time); $d[5]+=1900; $d[4]++; map {$_='0'.$_ if $_<10;} @d; return "$d[5]-$d[4]-$d[3]"; },
    current_time => sub{ my @d = localtime(time); map {$_='0'.$_ if $_<10;} @d; return "$d[2]:$d[1]:$d[0]"; },
    month        => sub{ $_ = shift; my @m = qw( January February March April May June July August September October November December ); return $m[$_-1]; },
};

## exec &begin link in DEFAULT subsection with REDIRECT_URL parameter
module( '&begin', "/DEFAULT.hash", $ENV{'REDIRECT_URL'} );
#-0
my $body;
eval {
    ## get result from subsections with $ENV{'REDIRECT_URL'} link
    $body = module($ENV{'REDIRECT_URL'});
};
#-100

module( '&end', "/DEFAULT.hash", $ENV{'REDIRECT_URL'} );

if ( $@ ) {
    to_log( $@ );
    $body = $@ if $CONFIG->{show_errors};
}

if ( $template->error() ) {
    to_log( $template->error() );
    $body = $template->error() if $CONFIG->{show_errors};
}

if ( !$body && !$tt->{content} && !defined $SESSION->param('slogin') ) {
    print "Status: 404 Not Found\n\n";
} elsif ( $header && $header eq 'clear' ) {
    ## get clear template
    print $q->header(-charset=>"utf-8");
    $template->process('clear.tpl', { body=>$body, %$tt, });
} elsif ( $header ) {
    ## if there is any information in header - show it
    print $header."\n\n";
    print $body;
} else {
    my $cookie = $q->cookie(-name=>'CGISESSID',
                            -value=>$SESSION->id(),
                            -expires=>$CONFIG->{session_expires},
                            -path=>'/',
                            -domain=>$CONFIG->{site},
                            );

    print 
        $q->header(-charset=>"utf-8",
            -cookie=>$cookie,
            -Pragma        => 'no-cache',
            -Cache_Control => join(', ', qw(
                private
                no-cache
                no-store
                must-revalidate
                max-age=0
                pre-check=0
                post-check=0
            )),
        );

    my $page=$template->process('index.tpl', { body=>$body, }, );
#-100
    if ( $template->error() ) {
        to_log( $template->error() );
        $page = $template->error() if $CONFIG->{show_errors};
    }

    print $page;
    print "\n<!-- ".(tv_interval($time_interval)*1000)." ms -->";

    cache_save ( $page );

}
