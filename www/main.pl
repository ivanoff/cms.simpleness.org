#!/usr/bin/perl

use strict;
use warnings;
use lib '../modules';

use Time::HiRes qw(gettimeofday tv_interval);

use DBI;
use Template;
use CGI;

use CGI::Session;
use Time::HiRes qw(gettimeofday tv_interval);
use Digest::MD5 qw( md5_hex );
use File::stat;

use CONFIG;
use DATABASE;
use TRANSLATE;
use MAIN;

our ( $db, $q, $t, $tt, $template, $SESSION, $header, $cache, );

my $time_interval = [gettimeofday()];

$q = new CGI;
$SESSION = new CGI::Session("driver:File", undef, {Directory=>$CONFIG->{cache_dir}});
if($q->param('_SESSION_ID')) {
    $SESSION = CGI::Session->load( "driver:File", $q->param('_SESSION_ID'), {Directory=>$CONFIG->{cache_dir}} );
    if ( $SESSION->is_expired ) {
	$SESSION->delete();
	$SESSION->flush();
    }
}

## Check for cached page and load it if found
$_ = md5_hex (($ENV{'SERVER_NAME'}||'').($ENV{'REQUEST_URI'}||''));
my $cache_dir = $CONFIG->{cache_dir}.'/cache_'.substr($_, 0, 1);
if ( defined $ENV{'REQUEST_METHOD'} && $ENV{'REQUEST_METHOD'} ne 'POST' 
    && !defined $SESSION->param('slogin')
    && -e "$cache_dir/cache_$_" 
    && stat("$cache_dir/cache_$_")->mtime > time ) {
	print "Content-Type: text/html; charset=utf-8\n\n";
	open F, "$cache_dir/cache_$_";
	print $_ foreach <F>;
	print "\n<!-- ".(tv_interval($time_interval)*1000)."ms cache $_ -->";
	close F;
	die();
}

## Get current language
$ENV{'SERVER_NAME'} =~ /^(?:www\.)?(?:(\w\w)\.)?/;
my $lang = $1 || $CONFIG->{default_language};
unless ( grep {$_ eq $lang} @{$CONFIG->{languages}} ) {
    print "Status: 404 Not Found\n\n";
    exit 0;
}

$cache = $CONFIG->{cache};

$t = TRANSLATE->new($lang);
$db = DATABASE->new;
$template = Template->new($CONFIG_TEMPLATE);

## Default variables for Template Toolkit
$tt = {
    v	=> {$q->Vars},
    uri	=> $ENV{'REDIRECT_URL'},
    referer	=> $ENV{'HTTP_REFERER'},
    session	=> sub { $_=shift; $SESSION->param($_) },
    login	=> $SESSION->param('slogin'),
    config	=> $CONFIG,
    languages	=> $CONFIG->{languages},
    languages_t	=> $CONFIG->{languages_t},
    default_language	=> $CONFIG->{default_language},
    t	=> sub{ $_=shift; return $t->t($_); },
    language	=> $t->{'language'},
    direct_rtl	=> sub{ $t->{'language'} =~ /(il|fa|ar)/ },
    access	=> access( $ENV{'REDIRECT_URL'}, $SESSION->param('slogin') ),
    current_date => sub{ my @d = localtime(time); $d[5]+=1900; $d[4]++; map {$_='0'.$_ if $_<10;} @d; return "$d[5]-$d[4]-$d[3]"; },
    current_time => sub{ my @d = localtime(time); map {$_='0'.$_ if $_<10;} @d; return "$d[2]:$d[1]:$d[0]"; },
    month	=> sub{ $_ = shift; my @m = qw( January February March April May June July August September October November December ); return $m[$_-1]; },
};

## exec &begin link in DEFAULT subsection with REDIRECT_URL parameter
module( '&begin', "/DEFAULT.sub", $ENV{'REDIRECT_URL'} );

my $body;
eval {
    ## get result from subsections with $ENV{'REDIRECT_URL'} link
    $body = module($ENV{'REDIRECT_URL'});
};
if ( $CONFIG->{show_errors} ) {
    $body = $@ if $@;
    $body = $template->error() if $template->error();
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
                             -expires=>'+1h',
                             -path=>'/',
                             -domain=>$CONFIG->{site},
            		);

    print 
	$q->header(-charset=>"utf-8", -lang => 'ru-RU',
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
    my $page;
    $template->process('index.tpl', { body=>$body, %$tt, }, \$page) || do( $page=$template->error() );
    print $page;
    print "\n<!-- ".(tv_interval($time_interval)*1000)."ms -->";

    ## if need to cache page - cache page
    if ( $cache && !defined $SESSION->param('slogin') && !$q->https ) {
	$_ = md5_hex (($ENV{'SERVER_NAME'}||'').($ENV{'REQUEST_URI'}||''));
	my $cache_dir = '../tmp/cache_'.substr($_, 0, 1);
	`mkdir $cache_dir` unless -e $cache_dir;
	open F, '>', "$cache_dir/cache_$_";
	print F $page;
	close F;
	utime time+$CONFIG->{cache_time}, time+$CONFIG->{cache_time}, "$cache_dir/cache_$_";
    }

}
