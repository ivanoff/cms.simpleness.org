package MAIN::Update;

use strict;
use warnings;
use Digest::MD5 qw( md5_hex );
use WWW::Mechanize::GZip;
use Text::Diff;

our $VERSION = '0.2';
our @ISA     = qw( Exporter );
our @EXPORT  = qw( update need_to_update file_to_md5 get_remote_content compare );

sub file_to_md5 {
print $_[0]."\n";
    return 0 unless @_ || !-f $_[0];
    open F, '<', $_[0];
    my $content = join '', <F>;
    close F;
    return md5_hex( $content );
}

sub need_to_update {
    my $timestamp = shift || time;
    my @t = localtime( $timestamp );
    $t[4]++;
    $t[5]+=1900;
    map { $_ = '0'.$_ if $_<10 } @t[0..4];
    @t = reverse @t;
    my $time = (join '-', @t[3..5]).';'.(join ':', @t[6..8]).';'.$t[2].';'.$t[1] ;
    return 0 if $time !~ $main::CONFIG->{update_frequency_regexp};
    return 0 if (stat($main::CONFIG->{update_rules_file}))[9] > time;
    return 1;
}

sub get_remote_content {
    my $file = shift;
    return 0 unless $file;
    return 0 if $file =~ /\.\./;
    my $mech = WWW::Mechanize::GZip->new();
    my $f = $mech->get( "https://raw.github.com/ivanoff/cms.simpleness.org/master/".$file );
    return ( $mech->content =~ /This is not the web page/ )? 0 : $mech->content;
}

sub compare {
    my ( $old, $new ) = @_;
    return diff \$old, \$new;
}

sub update {
    utime time+$main::CONFIG->{update_rules_timeout}, 
          time+$main::CONFIG->{update_rules_timeout}, $main::CONFIG->{update_rules_file};
    open my $log, '>>', $main::CONFIG->{update_log_file};

    close $log;
}

1;
