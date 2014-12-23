package MAIN::Cache;

use strict;
use warnings;

use MAIN::Laconic;
use File::Path qw( make_path );
use Digest::MD5 qw( md5_hex );

use Cache::Memcached::Fast;

our $VERSION = '0.3';
our @ISA     = qw( Exporter );
our @EXPORT  = qw( cache_save cache_delete cache_delete_page cache_load cache_md5_filename );

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
    return 0 if ( session('slogin') );
    my $content = shift;
=c
    make_path( &cache_dir ) unless -e &cache_dir;
    open F, '>', &cache_filename;
    print F $content;
    close F;
    utime time+$main::CONFIG->{cache_time}, time+$main::CONFIG->{cache_time}, &cache_filename;
=cut
my $memd = new Cache::Memcached::Fast({ servers => ['localhost:11211'] });
$memd->add( &cache_md5_filename, $content, $main::CONFIG->{cache_time} ); 
    return 1;
}

sub cache_delete {
    my $cache_name = shift;
    unlink $cache_name if -e $cache_name;
    my $memd = new Cache::Memcached::Fast({ servers => ['localhost:11211'] });
    $memd->delete( $cache_name );
    return 1;
}

sub cache_delete_page {
    $ENV{'REQUEST_URI'} = shift if @_;
    cache_delete( &cache_filename );
    return 1;
}

sub cache_load {
    return 0 if !$main::CONFIG->{cache}
             || $ENV{'REQUEST_METHOD'} eq 'POST'
             || ( $main::index_session && $main::index_session->{slogin} )
#             || !-e &cache_filename
#             || (stat(&cache_filename))[9] < time ;
;

my $memd = new Cache::Memcached::Fast({ servers => ['localhost:11211'] });
my $result = $memd->get( &cache_md5_filename );
return 0 unless $result;
$result .= "<!-- ".&cache_md5_filename." -->\n";
return [$result];

#    open F, &cache_filename;
#    my @result = <F>;
#    close F;
#    push @result, "<!-- ".&cache_filename." ".( ((stat(&cache_filename))[9] - time)/60/60 )." -->\n";
#    return \@result;
}

1;
