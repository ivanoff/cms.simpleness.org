# fake CGI module
package CGI;

use strict;
use warnings;
use Exporter;

use Digest::MD5;
use File::Spec;

our ( @ISA, @EXPORT );
@ISA = qw( Exporter );
@EXPORT = qw( Vars param header cookie server_name https virtual_port );

# fake CGI::Session submodule in fake CGI module. 
{
    package CGI::Session;
    our @ISA = qw( CGI );
    sub new {
        my ( $class, $params ) = @_;
        $params ||= {};
        my $self = $params;
        bless $self, ref $class || $class;

        $self->{_ENABLED} = $params->{Session_enabled};
        my $session_id = $self->id;
        my $vars = $self->restore_vars( $session_id );
        # create new session id
        # to-do session time
        if( $vars->{_SESSION_REMOTE_ADDR} && $vars->{_SESSION_REMOTE_ADDR} ne $ENV{REMOTE_ADDR} ) {
            $ENV{HTTP_COOKIE} = '';
            $vars = {};
            $session_id = $self->id;
        }
        $self->{vars} = $vars;
        $self->{vars}{_SESSION_ID} = $session_id;
        $self->{vars}{_SESSION_ATIME}   = time();
        $self->{vars}{_SESSION_CTIME} ||= time();
        $self->{vars}{_SESSION_REMOTE_ADDR} = $ENV{REMOTE_ADDR} || "";
        $self->{session_dir} = $params->{Directory} || File::Spec->tmpdir();
        mkdir $self->{session_dir} if !-e $self->{session_dir};
        return $self;
    };

    sub id {
        my $self = shift;
        my $id = $1 if $ENV{HTTP_COOKIE} && $ENV{HTTP_COOKIE} =~ /CGISESSID=([0-9a-f]{32})/;
        if( !$id ) {
            my $md5 = Digest::MD5->new();
            $md5->add($$ , time() , rand(time) );
            $id = $md5->hexdigest();
        }
        return $id;
    }

    sub restore_vars {
        my ( $self, $session_id ) = @_;
        my $file_name = $self->{Directory}.'/cgisess_'.$session_id;
        if ( !-e $file_name ) {
            $self->{_CHANGED} = $self->{_ENABLED};
            return {};
        }
        $self->{_ENABLED} = 1;
        my $vars = eval { do $file_name; };
        return ( ref $vars eq 'HASH' )? $vars : {};
    }

    sub header {
        my $self = shift;
        return $self->main::header( { 'Set-Cookie' => "CGISESSID=$self->{vars}{_SESSION_ID}; domain=admin.clear; path=/; expires=".$self->expire(30000) } );
#domain=admin.clear; path=/; expires=Mon, 26-May-2014 20:27:32 GMT
#        return $self->main::header( { 'Set-Cookie' => "CGISESSID=$self->{vars}{_SESSION_ID}; path=/ Date: ".$self->expire } );
    }

    sub param {
        my ( $self, $var, $val ) = @_;
        return $self->{vars}{$var} unless $val;
        $self->{_CHANGED} = 1;
        $self->{_ENABLED} = 1;
        $self->{vars}{$var} = $val;
    }

    sub is_expired {
        return 0;
    }

    sub clear {
        my ( $self, $vars ) = @_;
        $vars = [ $vars ] if ref $vars ne 'ARRAY';
        $self->{vars}{$_} = undef foreach @$vars;
    }

    sub delete {
        my $self = shift;
        $self->{_REMOVE_SESSION} = 1;
    }
    sub flush {
        my $self = shift;
#        $self = $self->new(); #!!!???
    }

    sub expire {
        my ( $self, $_ ) = @_;
        my $date = time;
        $_ = '30m' unless $_;
        $date += $1 if /^(\d+)$/;
        $date += $1 * 60 if /^\+(\d+)m$/;
        $date += $1 * 60 * 60 if /^\+(\d+)h$/;
        $date += $1 * 60 * 60 * 24 if /^\+(\d+)d$/;
        $date += $1 * 60 * 60 * 24 * 31 if /^\+(\d+)M$/; # to-do
        return $self->expire_time( $date );
    }

    sub DESTROY {
        my $self = shift;
        my $file = $self->{Directory}.'/cgisess_'.$self->{vars}{_SESSION_ID};
        if ( $self->{_REMOVE_SESSION} ) {
            unlink $file if -e $file;
            return 1;
        }
        return 0 unless $self->{_CHANGED};
        use Data::Dumper;
        $Data::Dumper::Terse = 1;
        $Data::Dumper::Indent = 0;
        open my $f, '>', $file;
        print {$f} '$D = '.( Dumper( $self->{vars} ) ).';;$D';
        close $f;
    }

#http://search.cpan.org/~sherzodr/CGI-Session-3.95/Session/Tutorial.pm
#$cookie = $cgi->cookie(CGISESSID => $session->id);
#print $cgi->header( -cookie=>$cookie );
#$sid = $cgi->cookie('CGISESSID') || $cgi->param('CGISESSID') || undef;
#$session    = new CGI::Session(undef, $sid, {Directory=>'/tmp'});

    1;
}

sub new {
    my ( $class, $params ) = @_;
    my $self = {};
    $params->{Session_enabled} = 1 unless defined $params->{Session_enabled};
    
    my @get = split '&', $ENV{QUERY_STRING} if $ENV{QUERY_STRING};
    foreach ( @get ) {
        $self->{vars}{$1} = $2 if /(.*?)=(.*)/;
    }

    my @post = <STDIN> if $ENV{REQUEST_METHOD} eq 'POST';
    my $boundary = $1 if $ENV{CONTENT_TYPE} && $ENV{CONTENT_TYPE} =~ /boundary=(.*)/;
    if( $boundary ) {
        my @post = split $boundary, join '', @post;
        foreach ( @post ) {
            my $name = $1 if /name="(.*?)".*/;
            next unless $name;
            my $value = $1 if /\r?\n\r?\n(.*)/s;
            $value =~ s/(\r?\n-+)?$//s;
            $self->{vars}{$name} = $value;
            if( /filename="(.*?)".*/ ) {
                $self->{vars}{$name} = $1;
                $self->{files}{$name} = $value;
            }
        }
    } elsif( @post ) {
        foreach ( split '&', $post[0] ) {
            $self->{vars}{$1} = $2 if /(.*?)=(.*)/;
        }
    }

    $self->{vars} ||= {};

    bless $self, ref $class || $class;

#### !!! проверять на ip и время жизни сессии !!! ###
#    $self->{CONFIG}{session_dir} = $params->{Directory} || File::Spec->tmpdir();
#    if ( $ENV{HTTP_COOKIE} && $ENV{HTTP_COOKIE} =~ /CGISESSID=([0-9a-f]{32})/ && -e $self->{CONFIG}{session_dir}."/cgisess_$1" ) {
#        $self->{session}{id} = $1;
#        $self->{session}{vars} = eval { local $SIG{__DIE__}; do $self->{CONFIG}{session_dir}."/cgisess_$self->{session}{id}"; };
#    }
#    $self->{session}{id} ||= $self->id;
##$D = {'sid' => '1','_SESSION_ID' => '55aa88422d45a7caa8bec586c9e13fa5','ip' => '127.0.0.1','show_addthis' => 1,'slogin' => '21232f297a57a5a743894a0e4a801fc3','sgroup' => 'root','_SESSION_REMOTE_ADDR' => '127.0.0.1','_SESSION_CTIME' => 1387968713,'_SESSION_ATIME' => 1387971310};;$D
####
    $self->{Session} = CGI::Session->new( $params );

    return $self;
}

sub DESTROY {
    my $self = shift;
    if ( $self->{files_tmp} ) {
        unlink $self->{files_tmp}{$_} foreach keys %{$self->{files_tmp}};
    }
}

sub header {
    my ( $self, $p ) = @_;
    my $add = join "", map { "$_: $p->{$_}\n" } grep { $_ !~ /-cookie|-type/ } keys %$p;

    $p->{-type}   ||= 'text/html';
    $p->{-cookie} ||= $self->{Session}->id();

    my $current_date = $self->{Session}->expire( 0 );
    my $expires_date = $self->{Session}->expire( ( $self->{Session}->{_ENABLED} || $self->{Session}{vars}{sid} )? $main::CONFIG->{session_expires} : -1 );
    my $set_cookie = "Set-Cookie: CGISESSID=$p->{-cookie}; domain=$main::CONFIG->{site}; path=/; expires=$expires_date";

return "Content-Type: $p->{-type}; charset=utf-8
Date: $current_date
Pragma: no-cache
Cache-control: private, no-cache, no-store, must-revalidate, max-age=0, pre-check=0, post-check=0
$set_cookie
$add
";

}

sub cookie {
    my ( $self, %p ) = @_;
    my $exp_date = expire_time(time+$p{-expires});
    my $path = $p{-path} || '/';
    return "$p{-name}=$p{-value}; path=$path; expires=$exp_date";
}

sub Vars {
    my $self = shift;
    return { %{$self->{vars}}, %{$self->{Session}{vars}} };
}

sub param {
    my ( $self, $name, $val ) = @_;
    $self->{vars}{$name} = $val if $val;
    return unescape( ( defined $self->{vars}{$name} )? $self->{vars}{$name} : $self->{Session}{vars}{$name} );
}

# to-do http://docstore.mik.ua/orelly/linux/cgi/ch05_02.htm

sub server_name { $ENV{SERVER_NAME} }

sub https { $ENV{HTTPS} }

sub virtual_port { $ENV{SERVER_PORT} }

sub expire_time {
    my ( $self, $_ ) = @_;
    my @m = ( $_ && /^(\d+)$/ )? gmtime( $1 ) : gmtime();
    my @wdays = qw/Sun Mon Tue Wed Thu Fri Sat/;
    my @months = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
    return sprintf('%s, %02d-%s-%04d %02d:%02d:%02d GMT',
                $wdays[$m[6]], $m[3], $months[$m[4]], $m[5] + 1900, $m[2], $m[1], $m[0]);
}

sub upload {
    my ( $self, $name ) = @_;
    return if !$name || !$self->{files} || !$self->{files}{$name};
    while ( my $tmp_filename = '/tmp/'.$self->{vars}{$name}.'_'.time.'_'.rand ) {
        next if -e $tmp_filename;
        $self->{files_tmp}{$name} = $tmp_filename;
        open my $f, '>', $tmp_filename;
        print {$f} $self->{files}{$name};
        close $f;
        open $f, '<', $tmp_filename;
        return $f;
    }
}

sub tmpFileName {
    my ( $self, $name ) = @_;
    return if !$name;
    if ( !$self->{files_tmp} || !$self->{files_tmp}{$name} ) {
        $self->upload( $name );
    }
    return $self->{files_tmp}{$name};
}


# thanks to Lincoln D. Stein
# unescape URL-encoded data
sub unescape {
  my $todecode = shift;

my $EBCDIC = "\t" ne "\011";

# (ord('^') == 95) for codepage 1047 as on os390, vmesa
our @A2E = (
   0,  1,  2,  3, 55, 45, 46, 47, 22,  5, 21, 11, 12, 13, 14, 15,
  16, 17, 18, 19, 60, 61, 50, 38, 24, 25, 63, 39, 28, 29, 30, 31,
  64, 90,127,123, 91,108, 80,125, 77, 93, 92, 78,107, 96, 75, 97,
 240,241,242,243,244,245,246,247,248,249,122, 94, 76,126,110,111,
 124,193,194,195,196,197,198,199,200,201,209,210,211,212,213,214,
 215,216,217,226,227,228,229,230,231,232,233,173,224,189, 95,109,
 121,129,130,131,132,133,134,135,136,137,145,146,147,148,149,150,
 151,152,153,162,163,164,165,166,167,168,169,192, 79,208,161,  7,
  32, 33, 34, 35, 36, 37,  6, 23, 40, 41, 42, 43, 44,  9, 10, 27,
  48, 49, 26, 51, 52, 53, 54,  8, 56, 57, 58, 59,  4, 20, 62,255,
  65,170, 74,177,159,178,106,181,187,180,154,138,176,202,175,188,
 144,143,234,250,190,160,182,179,157,218,155,139,183,184,185,171,
 100,101, 98,102, 99,103,158,104,116,113,114,115,120,117,118,119,
 172,105,237,238,235,239,236,191,128,253,254,251,252,186,174, 89,
  68, 69, 66, 70, 67, 71,156, 72, 84, 81, 82, 83, 88, 85, 86, 87,
 140, 73,205,206,203,207,204,225,112,221,222,219,220,141,142,223
	 );

if ($EBCDIC && ord('^') == 106) { # as in the BS2000 posix-bc coded character set
     $A2E[91] = 187;   $A2E[92] = 188;  $A2E[94] = 106;  $A2E[96] = 74;
     $A2E[123] = 251;  $A2E[125] = 253; $A2E[126] = 255; $A2E[159] = 95;
     $A2E[162] = 176;  $A2E[166] = 208; $A2E[168] = 121; $A2E[172] = 186;
     $A2E[175] = 161;  $A2E[217] = 224; $A2E[219] = 221; $A2E[221] = 173;
     $A2E[249] = 192;
   }
elsif ($EBCDIC && ord('^') == 176) { # as in codepage 037 on os400
  $A2E[10] = 37;  $A2E[91] = 186;  $A2E[93] = 187; $A2E[94] = 176;
  $A2E[133] = 21; $A2E[168] = 189; $A2E[172] = 95; $A2E[221] = 173;
}

  return undef unless defined($todecode);
  $todecode =~ tr/+/ /;       # pluses become spaces
    if ($EBCDIC) {
      $todecode =~ s/%([0-9a-fA-F]{2})/chr $A2E[hex($1)]/ge;
    } else {
	# handle surrogate pairs first -- dankogai. Ref: http://unicode.org/faq/utf_bom.html#utf16-2
	$todecode =~ s{
			%u([Dd][89a-bA-B][0-9a-fA-F]{2}) # hi
		        %u([Dd][c-fC-F][0-9a-fA-F]{2})   # lo
		      }{
			  utf8_chr(
				   0x10000 
				   + (hex($1) - 0xD800) * 0x400 
				   + (hex($2) - 0xDC00)
				  )
		      }gex;
      $todecode =~ s/%(?:([0-9a-fA-F]{2})|u([0-9a-fA-F]{4}))/
	defined($1)? chr hex($1) : utf8_chr(hex($2))/ge;
    }
  return $todecode;
}


1;
