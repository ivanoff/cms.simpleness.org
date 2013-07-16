#!/usr/bin/perl

###########################################################################
#                                                                         #
# Program      pre_update.pl                                              #
# Author       Dimitry Ivanov                                             #
# Description  prepare update script                                      #
#                                                                         #
#   pre_update.pl command line parameters:                                #
#             pre_update.pl [parameters]                                  #
#             pre_update.pl --help                                        #
#                                                                         #
###########################################################################

use strict;
use warnings;
use Getopt::Long;
use lib '..';
use CONFIG;
use MAIN::Update;

#print keys %{&filelist};
die "can't find update file ../$CONFIG->{update_rules_file}" unless -f '../'.$CONFIG->{update_rules_file};
my $up = eval { local $SIG{__DIE__}; do '../'.$CONFIG->{update_rules_file} };
die "error in ../$CONFIG->{update_rules_file}" if ref $up ne 'HASH';

my ( $h, $v, $c, $a, $r, $l, $m );
GetOptions ( 
        "help"  => \$h, 
        "version:f" => \$v, 
        "commit"    => \$c, 
        "ls"    => \$l, 
        "miss"  => \$m, 
        "add=s" => \$a, 
        "remove=s"  => \$r, ) or die( &help_message );
die( &help_message ) if $h || !grep { defined $_ } ( $v, $c, $a, $r, $l, $m );

if ( (defined $v && $v =~ /^\d+(\.\d+)?$/) || $c ) {
    $v = $up->{version} + 0.01;
    print "Current version: ".$up->{version}."\n";
    die "long jump to new version" if $v > $up->{version}+1;
    die "backward version" if $v && $v < $up->{version};
    if ( $v ) {
        print "New version: ".$v."\n";
        $up->{version} = $v;
        foreach ( keys %{$up->{files}} ) {
            $up->{files}{$_}=file_to_md5('../../'.$_);
        }
        save_rules( $up );
    }
}

if ( $l ) {
    foreach my $file ( sort keys $up->{files} ) {
        print $file."\n";
    }
}

if ( $m ) {
    my $all_files = &filelist;
    foreach my $file ( sort keys %$all_files ) {
        next if $up->{files}{'/'.$file};
        print $file."\n";
    }
    foreach my $file ( sort keys $up->{files} ) {
        print "!".$file."\n" unless $all_files->{$file};
    }
}

if ( $a ) {
    foreach my $file ( split ',', $a ) {
        $up->{files} = { %{$up->{files}}, %{filelist($file)} };
    }
    save_rules( $up );
}

if ( $r ) {
    foreach my $regex ( split ',', $r ) {
        $regex =~ s/\./\./g;
        $regex =~ s/\*/.*/g;
        $regex =~ s/\?/./g;
        foreach ( keys %{$up->{files}} ) {
            delete $up->{files}{$_} if /$regex/;
        }
    }
    save_rules( $up );
}

sub hash_expand {
    my ( $hash, $tab ) = @_;
    my $space = ('    ' x ($tab++));
    return "'$hash'" if ref $hash ne 'HASH';
    my $result;
    $result .= $space."{\n";
    foreach (sort keys %$hash) {
        $result .= $space."'$_' => ".hash_expand( $hash->{$_}, $tab ).",\n";
    }
    $result .= $space."}";
    return $result;
}

sub save_rules {
    my $hash = shift;
    open F, '>', '../'.$CONFIG->{update_rules_file};
    print F "#This file was generated automaticly\n";
    print F "#Please, don't change anything in this file\n";
    print F hash_expand($hash);
    close F;
}

sub filelist {
    my $result = {};
    my $mask = shift || '*';
    foreach ( <../../$mask> ) {
        return {} if m%/(\.svn|\.git|temp|tmp)/%;
        /^(?:\.\.\/){2}(.*)$/;
        $result = { %$result, %{filelist( $1.'/*' )} } if -d;
        $result->{$1} = file_to_md5($_) if -f;
    }
    return $result;
}

sub help_message {
<<EOF;
Prepare update file
Usage:  $0 [parameters] [command]

Command line parameters:
  -h,  --help           show this help
  -v,  --version        show/change current version
  -c,  --commit         commit with new version release
  -l,  --ls             list files
  -a,  --add            add files to update list
  -r,  --remove         remove files from update list

EOF
}

