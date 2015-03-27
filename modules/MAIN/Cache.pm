package MAIN::Cache;

use strict;
use warnings;

use MAIN::Laconic;
use File::Path qw( make_path );
use Digest::MD5 qw( md5_hex );
use Cache::Memcached::Fast;

our $VERSION = '0.4';
our @ISA     = qw( Exporter );
our @EXPORT  = qw( cache_save cache_delete cache_delete_page cache_load cache_md5_filename cache_url );

sub cache_url {
    return ( ( $ENV{'SERVER_NAME'} || '' ) . ( $ENV{'REQUEST_URI'} || '' ) );
}

sub cache_md5_filename {
    md5_hex ( &cache_url );
}

sub cache_dir {
    $main::CONFIG->{cache}{file_md5}{dir}.'/'.substr(&cache_md5_filename, 0, 1).'/'.substr(&cache_md5_filename, 0, 2);
}

sub cache_filename {
    &cache_dir . "/" . &cache_md5_filename;
}

sub cache_save {
    return 0 if !$::CONFIG->{cache};
    return 0 if ( session('slogin') );

    my $content = shift;

    if ( $::CONFIG->{cache}{memcached} ) {
        my $memd = new Cache::Memcached::Fast( $::CONFIG->{cache}{memcached} );
        $memd->set( &cache_url, $content ); 
    }

    if ( $::CONFIG->{cache}{file} ) {
        my ( $path, $name ) = ( $1, $2 ) if &cache_url =~ m%(.*)/(.*?)$%;
        $path = $::CONFIG->{cache}{file}{dir} . "/" . $path;
        $name .= $::CONFIG->{cache}{file}{ext};
        make_path( $path ) unless -e $path;
        open F, '>', "$path/$name";
        print F $content;
        close F;
        utime time+$::CONFIG->{cache}{file}{expire}
            , time+$::CONFIG->{cache}{file}{expire}
            , "$path/$name";
    }

    if ( $::CONFIG->{cache}{file_md5} ) {
        make_path( &cache_dir ) unless -e &cache_dir;
        open F, '>', &cache_filename;
        print F $content;
        close F;
        utime time+$::CONFIG->{cache}{file_md5}{expire}
            , time+$::CONFIG->{cache}{file_md5}{expire}
            , &cache_filename;
    }

    return 1;
}

sub cache_delete {
    my $cache_name = shift;
    unlink $cache_name if $::CONFIG->{cache}{file_md5} && -e $cache_name;
    if ( $::CONFIG->{cache}{memcached} ) {
        my $memd = new Cache::Memcached::Fast( $::CONFIG->{cache}{memcached} );
        $memd->delete( $cache_name );
    }
    return 1;
}

sub cache_delete_page {
    $ENV{'REQUEST_URI'} = shift if @_;
    cache_delete( &cache_filename );
    return 1;
}

sub cache_load {
    return 0 if !$::CONFIG->{cache}
         || $ENV{'REQUEST_METHOD'} eq 'POST'
         || ( $::index_session && $::index_session->{slogin} );

    my $result;

    if ( $::CONFIG->{cache}{memcached} ) {
        my $memd = new Cache::Memcached::Fast( $::CONFIG->{cache}{memcached} );
        $result = $memd->get( &cache_url );
        $result .= "<!-- ".&cache_url." memcached -->\n" if $result;
    }

    if ( $::CONFIG->{cache}{file} ) {
        my $file = $::CONFIG->{cache}{file}{dir} . "/" . &cache_url . $::CONFIG->{cache}{file}{ext};
        return 0 if !-e $file || (stat( $file ))[9] < time ;
        open F, $file;
        $result = join '', <F>;
        close F;
        $result .= "<!-- $file ".( ((stat( $file ))[9] - time)/60/60 )." -->\n" if $result;
    }

    if ( $::CONFIG->{cache}{file_md5} ) {
        return 0 if !-e &cache_filename || (stat(&cache_filename))[9] < time ;
        open F, &cache_filename;
        $result = join '', <F>;
        close F;
        $result .= "<!-- ".&cache_filename." ".( ((stat(&cache_filename))[9] - time)/60/60 )." -->\n" if $result;
    }

    return $result;
}

1;
