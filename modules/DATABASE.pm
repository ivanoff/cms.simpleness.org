#!/usr/bin/perl

package DATABASE;

use strict;
use DBI;

sub new {
    my $class = shift;
    my $self = {};
    my $dsn = 'DBI:'.$main::CONFIG->{'db_type'}
                .':dbname='.$main::CONFIG->{'db_dbname'}
                .';host='.$main::CONFIG->{'db_host'};
    my $dbh = DBI->connect($dsn, $main::CONFIG->{'db_user'}, $main::CONFIG->{'db_password'}, {PrintError => 1});

    unless( $dbh ) {
        to_log( "[SMART][irony] Error while DBI connect. Try to create database and import all data." );
        `mysql -u$main::CONFIG->{'db_user'} -p$main::CONFIG->{'db_password'} -e "create database $main::CONFIG->{'db_dbname'}"`;
        `mysql -u$main::CONFIG->{'db_user'} -p$main::CONFIG->{'db_password'} $main::CONFIG->{'db_dbname'} < ../install.sql`;
        $dbh = DBI->connect($dsn, $main::CONFIG->{'db_user'}, $main::CONFIG->{'db_password'}, {PrintError => 1});
    }

    $self->{'connect'} = \$dbh;
    $self->{'prefix'} = $main::CONFIG->{'db_table_prefix'};
    bless $self, ref $class || $class;
    return $self;
}

sub sql {
    my ( $self, $sql, @params ) = @_;
    my $dbh = ${$self->{'connect'}};

    my $sth = $dbh->prepare($sql);
    my $rv = $sth->execute(@params);

#    if ( 1 ) {
    if ( $dbh->errstr ) {
        to_log ( $dbh->errstr ); 
        to_log ( "SQL: $sql" ); 
        to_log ( "PARAMETERS: ". (join ", ", @params) ); 
    }
    my @result;

    if($sth->{NUM_OF_FIELDS}) {
        push @result, $_ while $_ = $sth->fetchrow_hashref;
    }

    $sth->finish();

    return \@result;
}


sub DESTROY {
    my $self = shift;
    my $dbh = ${$self->{'connect'}};
    $dbh->disconnect() if $dbh;
}

1;
