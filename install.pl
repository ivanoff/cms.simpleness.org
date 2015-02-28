#!/usr/bin/perl

## Check and install modules
## Get necessary parameters from keyboard
## Check database connection
## Update config file
## Import and update database

use strict;
use lib 'modules';
use CONFIG;
use Getopt::Long;

my $yes_default;
GetOptions ( "yes" => \$yes_default );

my @modules = qw( 
    WWW::Mechanize
    WWW::Mechanize::GZip
    DBI
    Template
    Time::HiRes
    Email::Send
    Email::MIME::Creator
    IO::All
    Digest::MD5
    File::Path
    File::Copy
    POSIX
    Encode
    Text::Diff
    Spreadsheet::ParseExcel
  );

sub param {
    my ( $text, $default, $params ) = @_;
    return $default if $yes_default;
    $text .= " [$default]" if $default;
    print "$text: ";
    my $result = <>;
    chomp $result;
    $result = $default unless $result;
    return $result;
}

print "Simpleness CMS installer\n";
print "If modules/CONFIG.pm is updated, try $0 -y for non-interactive install\n";
print "For more info: http://cms.simpleness.org\n";

### Install modules ###
my $check_modules;
foreach my $module ( @modules ){
    eval { $_= $module; $_ .= ".pm"; s%::%/%g; require $_; };
    $check_modules->{$module} = $@;
}

print "\nInstalled moduses: ";
print (( join ", ", grep { !$check_modules->{$_} } keys %$check_modules )."\n");

my @install = grep { $check_modules->{$_} } keys %$check_modules;
if(@install) {
    print "\nModules need to be install:\n". (join "\n", @install) ."\n";
    if( param( "Do you want to install missed modules?", 'y' ) eq 'y' ) {
=c
    `perl -MCPAN -e 'force install $_'` foreach ( @install );
# sudo apt-get install libspreadsheet-parseexcel-perl
=cut
    foreach ( @install ) {
        open my $p, '|-', "sudo perl -MCPAN -e 'shell'";
        print {$p} "force install $_\n";
        close $p;
    }
    } else {
    die("Please, install missed modules manually and start $0 again\n");
    }
}


### and check database connection ###
my ( $dsn, $dbh );
sub db_connect {
    $dsn = 'DBI:'.$CONFIG->{'db_type'}
        .':dbname='.$CONFIG->{'db_dbname'}
        .';host='.$CONFIG->{'db_host'};
    $dbh = DBI->connect($dsn, $CONFIG->{'db_user'}, $CONFIG->{'db_password'}, {PrintError => 1})
        or return $DBI::errstr;
    return 0;
}

#create database tec_odn;
#create user tec_odn;
#GRANT ALL PRIVILEGES ON `tec_odn%`.* TO `tec_odn`@`localhost` identified by 'tec_odnzzz';
#FLUSH PRIVILEGES;

my $answer;
print "\nChecking for database:\n";
while ( my $error = db_connect ) {
    print "cannot connect to database: $error\n";
    last if $yes_default;
    $answer = param( "\nDo you want to enter new database parameters?", 'y' );
    die("Please, define database parameters and re-run this script again\n") if $answer !~ /^y(es)?$/i;
    $CONFIG->{db_host} = param( "database host", $CONFIG->{db_host} );
    $CONFIG->{db_dbname} = param( "database name", $CONFIG->{db_dbname} );
    $CONFIG->{db_user} = param( "database user", $CONFIG->{db_user} );
    $CONFIG->{db_password} = param( "database password", $CONFIG->{db_password} );
}


### get parameters ###
my $pass = 'admin';
unless ( $yes_default ) {
    print "\nPlease, enter parameters below:\n";
    $CONFIG->{site}  = param( "site url",    $CONFIG->{site} );
    $CONFIG->{email} = param( "your e-mail", $CONFIG->{email} );
    $pass  = param( "password for admin area", 'admin' );
    
    
    ### Update config file ###
    open F, '<', 'modules/CONFIG.pm';
    my @cfg = <F>;
    close F;
    
    open F, '>', 'modules/CONFIG.pm';
    foreach ( @cfg ) {
    foreach my $p ( qw( site email db_type db_host db_dbname db_user db_password ) ) {
        s/(\b$p\b[\s\=\>]+)'.*'/$1'$CONFIG->{$p}'/;
    }
    print F $_;
    }
    close F;
}

### Import and update database ###
if( param( "Do you want import install.sql?", 'y' ) eq 'y' ) {
    open SQL, '<', 'install.sql';
    $dbh->do( $_ ) for split /;\n/, join( '', <SQL> );
    close SQL;
}

#my $sth = $dbh->prepare( "UPDATE base_users SET user_password='' WHERE user_login=?" );
#my $rv = $sth->execute( 'admin' );
#my $pass = 'tec_odnzzz';
my $sth = $dbh->prepare( "UPDATE base_users SET user_password=MD5(CONCAT(?,MD5(?),MD5(?))) WHERE user_login=?" );
my $rv = $sth->execute( $pass, 'admin', $pass.'admin', 'admin' );


### Remove this file
if( param( "Do you want to remove this unnecessary files?", 'y' ) eq 'y' ) {
    unlink foreach qw( install.pl install.sql log/.gitignore tmp/.gitignore );
}

