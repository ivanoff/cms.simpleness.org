#!/usr/bin/perl

## Check and install modules
## Get necessary parameters from keyboard
## Check database connection
## Import and update database
## Update config file

use strict;
use warnings;
use lib 'modules';
use CONFIG;

my @modules = qw( 
    WWW::Mechanize
    WWW::Mechanize::GZip
    DBI
    Template
    CGI
    CGI::Session
    Time::HiRes
    Email::Send
    Email::Send::Gmail
    Email::MIME::Creator
    IO::All
    Net::SMTP_auth
    Digest::MD5
    File::Path
    POSIX
    Encode
    Text::Diff
  );

    sub param {
	my ( $text, $default, $params ) = @_;
	$text .= " [$default]" if $default;
	print "$text: ";
	my $result = <>;
	chomp $result;
	$result = $default unless $result;
	return $result;
    }


### Install modules ###
    my $check_modules;
    foreach my $module ( @modules ){
	eval { $_= $module; $_ .= ".pm"; s%::%/%g; require $_; };
	$check_modules->{$module} = $@;
    }

    print "Installed moduses:\n";
    print (( join ", ", grep { !$check_modules->{$_} } keys %$check_modules )."\n");

    my @install = grep { $check_modules->{$_} } keys %$check_modules;
    if(@install) {
        print "Modules need to be install:\n". (join "\n", @install) ."\n";
        if( param( "Do you want to install missed modules?", 'y' ) eq 'y' ) {
	    `perl -MCPAN -e 'force install $_'` foreach ( @install );
        } else {
	    die("Please, install missed modules manually and start $0 again\n");
        }
    }


### get parameters ###

    print "Please, enter parameters below: ";
    $CONFIG->{site}  = param( "site url",    $CONFIG->{site} );
    $CONFIG->{email} = param( "your e-mail", $CONFIG->{email} );
    my $pass  = param( "password for admin area" );


### and check database connection ###
    my ( $dsn, $dbh );

    sub db_connect {
	$dsn = 'DBI:'.$CONFIG->{'db_type'}
        	.':dbname='.$CONFIG->{'db_dbname'}
        	.';host='.$CONFIG->{'db_host'};
	$dbh = DBI->connect($dsn, $CONFIG->{'db_user'}, $CONFIG->{'db_password'}, {PrintError => 1});
	return $DBI::errstr;
    }

    my $answer;
    while ( my $error = db_connect ) {
	unless ( $answer ) {
	    print "cannot connect to database: $error\n";
	    $answer = param( "Do you want to re-type database parameters?", 'y' );
	    last if $answer !~ /^y(es)?$/i;
	}
	$CONFIG->{db_host} = param( "database host", $CONFIG->{db_host} );
	$CONFIG->{db_name} = param( "database name", $CONFIG->{db_name} );
	$CONFIG->{db_user} = param( "database user", $CONFIG->{db_user} );
	$CONFIG->{db_password} = param( "database password", $CONFIG->{db_password} );
    }


### Update config file ###
    open F, '<', 'CONFIG.pm';
    my @cfg = <F>;
    close F;

    open F, '>', 'CONFIG.pm';
    foreach ( @cfg ) {
	foreach my $p ( qw( site email db_type db_host db_dbname db_user db_password ) ) {
    	    s/(\b$p\b[\s\=\>]+)'.*'/$1'$CONFIG->{$p}'/;
        }
	print F $_;
    }
    close F;

    
### Import and update database ###
    open F, '<', 'install.sql';
    $dbh->do( $_ ) for split /;\n/, join( '', <SQL> );
    close F;

#    my $sth = $dbh->prepare( $sql );
#    my $rv = $sth->execute();

    my $sth = $dbh->prepare( "UPDATE base_users SET user_password=MD5(CONCAT(?,MD5(?),MD5(?))) WHERE user_login=?" );
    my $rv = $sth->execute( $pass, 'admin', $pass.'admin', 'admin' );


### Remove this file
    if( param( "Do you want to remove this unnecessary $0 file?", 'y' ) eq 'y' ) {
        unlink foreach qw( $0 install.sql log/.gitignore tmp/.gitignore );
    }

