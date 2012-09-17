#!/usr/bin/perl

package DATABASE;

use strict;
use DBI;
use DBD::Log;

sub new {
    my ($class) = @_;
    my $self = {};
    my $dsn = 'DBI:'.$main::CONFIG->{'db_type'}.':dbname='.$main::CONFIG->{'db_database'};
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
        open F, '>>/tmp/ship.org.ua.log';
	print F "$sql\n"; 
	print F join "\n", @_ , "\n"; 
	print F $dbh->errstr."\n"; 
	close F;
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


## for logging updates
sub sql_log {
#    to_log ( @_ );
#    to_log ( {filename=>'/tmp/ship.org.ua.sql', data=>[ @_ ], } );

    my $self = shift;
    my $sql = shift;
    my $dbh = ${$self->{'connect'}};

    my $scalar = '';
    open( my $fh, "+>:scalar", \$scalar );
    $dbh = DBD::Log->new(
			dbi     => $dbh,
                	logFH   => $fh,
                	logThis => [ 'all', ],
        	    );

    my $sth = $dbh->prepare($sql);
    my $rv = $sth->execute(@_);

    close $fh;
    if ($scalar) {
	$scalar =~ s/^(\d+)[\s]*(.*)/$2; #$1/;
	$scalar =~ s/=,/='',/g;
	$scalar =~ s/,,/,'',/g;
	$scalar =~ s/,\s*\)/,'')/g;
	$scalar =~ s/\(\s*,/('',/g;
	$scalar =~ s/=\s*WHERE/='' WHERE/g;
	$scalar =~ s/CONCAT_WS\( ',',  \)/CONCAT_WS\( ',', '' \)/g;
	open LOG_SQL, ">>", $main::CONFIG->{'log_sql'};
	print LOG_SQL $scalar;
	close LOG_SQL;
    }

#    return $self->sql($sql, @_);

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
