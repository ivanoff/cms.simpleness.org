#!/usr/bin/perl

package DATABASE;

use strict;
use DBI;
use DBD::Log;

sub new {
    my ($class) = @_;
    my $self = {};
    my $dsn = 'DBI:'.$main::CONFIG->{'db_type'}
                .':dbname='.$main::CONFIG->{'db_dbname'}
                .';host='.$main::CONFIG->{'db_host'};
    my $dbh = DBI->connect($dsn, $main::CONFIG->{'db_user'}, $main::CONFIG->{'db_password'}, {PrintError => 1});
    $self->{'connect'} = \$dbh;
    $self->{'prefix'} = $main::CONFIG->{'db_table_prefix'};
    bless $self, ref $class || $class;
    return $self;
}

sub sql {
    use MAIN;
#    to_log ( @_ );
    my $self = shift;
    my $sql = shift;
    my $dbh = ${$self->{'connect'}};

    my $sth = $dbh->prepare($sql);
    my $rv = $sth->execute(@_);

#    if ( 1 ) {
    if ( $dbh->errstr ) {
        to_log ( $dbh->errstr ); 
        to_log ( "SQL: $sql" ); 
        to_log ( "PARAMETERS: ". (join ", ", @_) ); 
    }
    my @result;

    if($sth->{NUM_OF_FIELDS}) {    
        while(my ($r) = $sth->fetchrow_hashref()) {
            last unless defined($r);
            push @result, $r;
        }
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
