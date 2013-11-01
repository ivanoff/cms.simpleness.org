package MAIN;

use strict;
use warnings;

use Email::Send;
use Email::MIME::Creator;
use IO::All;
use Digest::MD5 qw( md5_hex );
use File::Path qw( make_path remove_tree );
use POSIX qw( strftime );
use Time::HiRes qw( gettimeofday tv_interval );

use CONFIG;
use MAIN::Cache;
use MAIN::Laconic;

our $VERSION = '0.1';
our @ISA     = qw( Exporter );

our @EXPORT_OK  = qw(
                $CONFIG $CONFIG_TEMPLATE $CONFIG_IMAGES
                redirect redirect2 back
                access 
                module
                to_log
                resize
                email
                md5_hex
                error
                cookie_expires
            );

our %EXPORT_TAGS = (
                all     => [ @EXPORT_OK ],
                laconic => [ qw( defaults title header ban you_cannot you_can_not process sql
                                t lang is_default_lang cache param session images) ],
                cache   => [ qw( cache_save cache_delete cache_load )],
                time    => [ qw( gettimeofday tv_interval ) ],
                file    => [ qw( make_path remove_tree ) ],
            );

our @EXPORT = map { @$_ } values %EXPORT_TAGS;

## get all access rules
sub access {
    $_ = eval { local $SIG{__DIE__}; do $CONFIG->{config_files_path}.'/access.pl' };
    return $_->{&session('sgroup')} if &session('sgroup') && $_->{&session('sgroup')};
    return {};
}

sub find_hash {
    my ( $link, $module ) = @_;
    my @additional = ( $ENV{'SERVER_NAME'}, '' );
    foreach my $additional_path ( @additional ) {
        my $path = $CONFIG->{modules_path}.'/'.$additional_path.'/';
        return $path.$module if $module && -f $path.$module;
        my @modules;
        push @modules, $1 while ( $link =~ m%/([\w\d]+[\w\d\.]*)%g );
        while ( @modules ) {
            my $file = $path."/".(join '/', @modules).".".$CONFIG->{modules_extension};
            return $file if -f $file;
            pop @modules;
        }
    }
    foreach my $additional_path ( @additional ) {
        my $default = $CONFIG->{modules_path}.'/'.$additional_path.'/DEFAULT.hash';
        return $default if -f $default;
    }
    return 0;
}

=head1 module
 get result from subsections $module with $link section and @arg arguments
 if there is no modules, system gets module, regards to path of link
 for example:
    $body = module( '&begin', "/DEFAULT.hash", 'abc', 123 );
        system will get module DEFAULT.hash in modules path, 
        then execute &begin subsection with ('abc', 123) parameters
    $body = module('/admin/news/edit/123');
        System will try to find /admin/news/edit/123.hash link, then /admin/news/edit.hash, 
        then /admin/news.hash and stop search, 'cause found last one.
        After that, system will find '/admin/news/edit/(\d+)' section in
        /admin/news.hash module by regexp with $link.
        Then, system execute this section with '123' argument.
=cut
sub module {
    my ( $link, $module, $arg ) = @_;
    $module = ($link)? find_hash( $link, $module ) : $CONFIG->{modules_path}."/.hash";
    my %main;
    if (-f $module) {
        my $ref = eval { local $SIG{__DIE__}; do $module; };

        return error( 3, $@ ) if $@;
        return error( 4, `cd $CONFIG->{modules_path} && perl -c $module 2>&1` ) unless $ref;

        return $ref unless ref($ref);
        if (ref($ref) eq 'HASH') { %main = (%main, %$ref); };
    }
    return $main{''}( @$arg ) unless $link;
    foreach (sort {length $b <=> length $a} keys %main) {
        if (my @arr = $link =~ /^$_$/ ) {
            return $main{$_}( @$arg, @arr );
        }
    }
    return '';
}

sub to_log {
    my ( $filename, @data ) = ( ref($_[0]) ne 'HASH' )? ( $CONFIG->{log_error}, @_ ):( $_[0]->{filename}, @{$_[0]->{data}} );
    open F, '>>', $filename;
    foreach ( @data ) {
        print F $ENV{REMOTE_ADDR};
        print F (strftime " [%F %T] - ", localtime);
        s/\r|\n//g;
        print F $_."\n";
    }
    close F;
}

sub error {
    my ( $error_no, $error_text ) = @_;
    to_log( $error_text );
    return ( $main::CONFIG->{show_errors} )? $error_text : 'err.#'.$error_no;
}


## 302 redirect
sub redirect {
    $_ = shift || '';
    my $url = shift || $main::q->server_name;
    my $lang = shift || '';
    my $rtype = shift || "302 Found\nCache-Control: no-cache, must-revalidate\nExpires: Sat, 26 Jul 1997 05:00:00 GMT";
    $url = $lang.'.'.$url if $lang && $lang ne lang('default');
    $main::header = "HTTP/1.1 $rtype";
    my $protocol = ($main::q->https)? 'https' : 'http';
    my $port = ($main::q->virtual_port != 80)? ':'.$main::q->virtual_port : '';
    print "location: $protocol://$url$port/$_\n\n";
}

## Javascript redirect
sub redirect2 {
    $_ = shift || '';
    my $url = shift || 'http://'.$CONFIG->{site};
    $url .= '/'.$_;
    return '<script type="text/javascript">window.location = "'.$url.'"</script>';
}

## redirect to HTTP_REFERER page
sub back {
    redirect( $1 ) if $ENV{'HTTP_REFERER'} =~ m%https?://.*?/(.*)%;
}

## resize image
sub resize {
    use Image::Magick;
    my ( $from, $to, $width, $height ) = @_;
    return 0 unless ($from && -e $from);
    my $img = Image::Magick->new;
    $img->Read($from);
    my ($w,$h) = $img->Get('width','height');
    my $new_height = $height;
    my $new_width = int($w * ($height / $h));
    if( ( $new_width < $width && $width < 200 ) || ( $new_width > $width && $width > 200 ) ) {
        $new_width = $width;
        $new_height = int($h * ($width / $w));
    }
    $img->Resize(width=>$new_width, height=>$new_height);
    if( $width<200 ) {
        $img->Crop( x=>(($new_width>$width)?int(($new_width-$width)/2):0), 
#            y=>(($new_height>$height)?int(($new_height-$height)/2):0), 
# vertical photo crop to top
            y=>0, 
            width=>$width, height=>$height);
    }
    $img->Sharpen();
=c
    $img->Normalize();
    $img->AutoLevel();
    $img->AutoGamma();
=cut
    $img->Write($to);
}

sub email {

    my $_ = shift;
    my $from = $_->{From} || $CONFIG->{email};
    my $to = $_->{To} || $CONFIG->{email};
    my $subject = $_->{Subject} || 'Message from website';
    my $email = Email::MIME->create(
        header => [
            From    => $from,
            To      => $to,
            Subject => $subject,
        ],
        body => $_->{Message} || 'This is a test message',
    );

    $email->header_set( 'Content-type' => 'text/plain; charset="utf-8"' );

if( keys %{$_->{Image}} ) {

    my @parts = (
      Email::MIME->create(
          attributes => {
              charset      => "UTF-8",
          },
              body => '',
      )
    );

    foreach my $img_name ( keys %{$_->{Image}} ) {
        next unless $img_name =~ /(jpg|jpeg|png|pdf|doc|docx|rtf|xls|tar|gz|txt)$/i;
        my $img = $_->{Image}->{$img_name};
        push @parts, 
        Email::MIME->create(
                attributes => {
                filename     => $img_name,
                content_type => "application/download",
                encoding     => "base64",
#                disposition  => 'attachment',
#                content_type => "image/jpeg",
#                encoding     => "quoted-printable",
                name         => $img,
            },
            body => io( $img )->all,
        );
    }

    $email->parts_set(
        [
                $email->parts,
            Email::MIME->create( parts => [ @parts ] ),
        ],
    );
}

    my $bulk = Email::Send->new;
    for ( qw[Sendmail SMTP Qmail] ) {
        $bulk->mailer($_) and last if $bulk->mailer_available($_);
    }
    my $rv = $bulk->send($email);

}

sub cookie_expires {
    my $ts = shift;
    my @wdays = qw/Sun Mon Tue Wed Thu Fri Sat/;
    my @months = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
    my @m = ($ts)? gmtime($ts) : gmtime();
    return sprintf('%s, %02d-%s-%04d %02d:%02d:%02d GMT',
                    $wdays[$m[6]], $m[3], $months[$m[4]], $m[5] + 1900, $m[2], $m[1], $m[0]);
}

=head1 MAIN

=head1 SYNOPSIS

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Email::Send>, L<Email::MIME::Creator>, L<Image::Magick>

=head1 AUTHOR

ivanoff, http://ivanoff.org.ua, 2@ivanoff.org.ua,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
