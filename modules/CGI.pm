# fake CGI module. wrote within 2 hrs. need to improve.
package CGI;

use strict;
use warnings;
use Exporter;

our ( @ISA, @EXPORT );
@ISA = qw( Exporter );
@EXPORT = qw( Vars param header cookie server_name https virtual_port );

sub new {
    my $class = shift;
    my $self = {};

    my @get = split '&', $ENV{QUERY_STRING};
    foreach ( @get ) {
        $self->{vars}{$1} = $2 if /(.*?)=(.*)/;
    }

    my @post = <STDIN>;
    my $boundary = $1 if $ENV{CONTENT_TYPE} && $ENV{CONTENT_TYPE} =~ /boundary=(.*)/;
    if( $boundary ) {
        my @post = split $boundary, join '', @post;
        foreach ( @post ) {
            my $name = $1 if /name="(.*?)".*/;
            next unless $name;
            my $value = $1 if /\r?\n\r?\n(.*)/s;
            $value =~ s/(\r?\n-+)?$//s;
            $self->{vars}{$name} = $value;
            $self->{files}{$name} = $1 if /filename="(.*?)".*/;
        }
    } else {
        foreach ( split '&', $post[0] ) {
            $self->{vars}{$1} = $2 if /(.*?)=(.*)/;
        }
    }

    bless $self, ref $class || $class;
    return $self;
}

sub header {
    my ( $self, %p ) = @_;
    my $cur_date = cookie_expires(time);
    my $add = join "", map { "$_: $p{$_}\n" } grep { $_ !~ /-cookie|-type/ } keys %p;
return $add.
"Set-Cookie: $p{-cookie}
Date: $cur_date
Content-Type: $p{-type}; charset=UTF-8

";
}

sub cookie {
    my ( $self, %p ) = @_;
    my $exp_date = cookie_expires(time+$p{-expires});
    my $path = $p{-path} || '/';
    return "$p{-name}=$p{-value}; path=$path; expires=$exp_date";
}

sub Vars {
    my $self = shift;
    return $self->{vars};
}

sub param {
    my ( $self, $name ) = @_;
    return unescape($self->{vars}{$name});
}

sub server_name { $ENV{SERVER_NAME} }

sub https { $ENV{HTTPS} }

sub virtual_port { $ENV{SERVER_PORT} }

sub cookie_expires {
    my $ts = shift;
    my @wdays = qw/Sun Mon Tue Wed Thu Fri Sat/;
    my @months = qw/Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec/;
    my @m = ($ts)? gmtime($ts) : gmtime();
    return sprintf('%s, %02d-%s-%04d %02d:%02d:%02d GMT',
                    $wdays[$m[6]], $m[3], $months[$m[4]], $m[5] + 1900, $m[2], $m[1], $m[0]);
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
