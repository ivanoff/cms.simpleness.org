#!/usr/bin/perl

# UNDER COUNSRUCTION
# but it works

package TRANSLATE;

use strict;

use utf8;
use Encode;

sub new {
    my ($class, $lang) = @_;
    my $self = {};

    $lang='en' unless $lang;
    $self->{'language'} = $lang;

    my $lang_file = $main::CONFIG->{config_path}.'/lang/'.$lang.'.pl';
    $self->{'language_file'} = $lang_file;

    if (-f $lang_file) {
	my $ref = eval { local $SIG{__DIE__}; do $lang_file };
	if (ref($ref) eq 'HASH') {
	    $self->{'words'} = $ref;
        } else {
    	    use File::Copy;
    	    copy($lang_file, $lang_file.'.tmp') unless(-f $lang_file.'.tmp');
        }
    }

    bless $self, ref $class || $class;
    return $self;
}

sub t {
    my $self = shift;
    my $word = shift;
    $word = '' unless $word;

    my $new_word = ${$self->{'words'}}{$word};
    if( $new_word ) {
        $word = $new_word if ( $new_word ne ' ' );
    } else {
#	$word = $self->new_word($word);
    }

    return $word;
}

sub tu {
    my $self = shift;
    my $word = shift;
    $word = $self->t( $word );
    utf8::decode( $word );
    return $word;
}

sub save_lang {
    my $self = shift;

    open FILE, '>:utf8', $self->{'language_file'};
    print FILE "{\n";
    print FILE "\t''\t=> ' ',\n" unless ${$self->{'words'}}{''};
    foreach my $key (sort {uc($a) cmp uc($b)} keys %{$self->{'words'}}) {
	my $key_c = $key;
	$key_c =~ s/\'/\\\'/g;
	${$self->{'words'}}{$key} =~ s/\'/\\\'/g;
	utf8::decode( ${$self->{'words'}}{$key} );
	print FILE "\t'$key_c'\t=> '".${$self->{'words'}}{$key}."',\n";
    }
    print FILE "};";
    close FILE;
}

sub translate {
    my $self = shift;
    my $word = shift;
    return $word if !$word || $word =~ /^\s+$/;
    my $new_word = $self->google_translate ( $word, @_ );
    return $new_word;
}

sub new_word {
    my $self = shift;
    my $word = shift;

    my $new_word = $self->google_translate ($word, 'en', $self->{'language'});
    $new_word = ' ' if $new_word eq $word;
    %{$self->{'words'}} = (%{$self->{'words'}}, $word=>$new_word);

    $self->save_lang();

    my $ref = eval { local $SIG{__DIE__}; do $self->{'language_file'} };
    if (ref($ref) ne 'HASH') {
	delete ${$self->{'words'}}{$word};
	$self->save_lang();
	open FILE_BAD, '>>'.$self->{'language_file'}.'.bad';
	print FILE_BAD "$word\n";
	close FILE_BAD;
    }

    return $new_word;
}

sub separate_by {
    my $self = shift;
    my ($separator, $max_length, $word_from) = @_;

    my @words;
    if(length($word_from)>$max_length) {
	my $word;
	foreach (split /$separator/, $word_from){
	    if(length($word.$_.$separator)>$max_length) {
		if(length($word)>$max_length) {
		    if($separator ne '. '){
			push @words, separate_by('. ', 400, $word);
		    }
		} else {
		    push @words, $word;
		}
		$word = $_.$separator;
	    } else {
		$word .= $_.$separator;
	    }
	}
	push @words, $word;
    } else {
	@words = ($word_from);
    }
    return @words;
}

sub google_translate {
=c
    my $self = shift;
    (my $word_from, my $lang_from, $_ ) = @_;
    utf8::decode( $word_from );

    s/ua/uk/;
    s/gr/el/;
    s/jp/ja/;
    s/ch/zh-CN/;
    s/il/iw/;

    my $lang_to = $_;
    return translate_ff( $word_from, $_ );
    
#    my @words = $self->separate_by ("</p>", 400, $word_from);    
#    my @words = $self->separate_by ("\n", 400, $word_from);    
    my @words = $self->separate_by (". ", 400, $word_from);    

    my @words_to;
    use REST::Google::Translate;
    REST::Google::Translate->http_referer('http://amdm.ru');
    foreach my $word (@words) {
	my $res = REST::Google::Translate->new( q => $word, langpair => $lang_from.'|'.$lang_to );
	my $word_to = ' ';
	$word_to = $res->responseData->translatedText unless $res->responseStatus != 200;
	push @words_to, $word_to;	
    }
    
    return join ('', @words_to);
=cut
}

=c
sub lingua_translate {
    my $self = shift;
    my ($word_from, $lang_from, $lang_to) = @_;
    use Lingua::Translate;

    my $xl8r = Lingua::Translate->new(	src => $lang_from,
					dest => $lang_to
				    );
    my $word_to = $xl8r->translate($word_from);

    return $word_to;
}
=cut

=sub lang_checking
    check tables for actual translation by id
=cut
sub lang_checking {
#print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
    my $self = shift;
    my $params = shift;
    return 0 unless $params->{table} && $params->{id} && $params->{id_main};
#return 0 if $params->{lang_to} ne 'ua';
    push @{$params->{dnd}}, $params->{id};

    $params->{lang_from} = $main::CONFIG->{default_language} unless $params->{lang_from};
    $params->{lang_to} = $self->{'language'} unless $params->{lang_to};
    $params->{lang_from} = 'ru' if $params->{lang_to} eq 'ua';
#    $params->{order} = "ORDER BY ".$params->{order} if $params->{order};

    open TMP, '>>/tmp/ship.org.ua.tmp';
    print TMP $params->{table}." : ".$params->{lang_from}." : ".$params->{lang_to}."\n";
    close TMP;

    my $db = $main::db;
    my $r = $db->sql("SELECT * FROM $params->{table} WHERE lang=? AND $params->{id} NOT IN 
		(SELECT $params->{id} FROM $params->{table} WHERE lang=?)", $params->{lang_from}, $params->{lang_to});
    return "$params->{table} - nothing to do" unless @$r;

    if ( $params->{lang_to} ne 'ua' ) {
#	return $params->{table} . " : " . $params->{lang_to} . " : " . (0+@$r) ;
    }
    
    my @keys = grep { $_ ne $params->{id_main} } keys %{$r->[0]} ;
    my %source;
    foreach my $row (@$r) {
	foreach my $key (@keys) {
	    next if $key eq 'lang';
	    next if ( grep { $_ eq $key } @{$params->{dnd}} );
	    $source{$row->{$key}} = 1;
	}
    }
    my $check_phrase = '01_2_34_56';
#    my $check_phrase = '00afpremmsxrreeddssaa';
##    my $check_phrase = '00000000000';
#    my $check_phrase = 'rem.googl.com';
#    my $check_phrase = 'Pixi.dixi.fixi';
#    my $check_phrase = 'www.ocmrennvtndkre.com';
#    my $separator = '($%)';
#    my $separator = '------';
    my $separator = ':::';
#    my $separator = 'smhnajsmdserqie';
#    my $separator = 'Mpienxif';
#    my $separator = 'www.smhnajsmdserqie.com';
    $source{$check_phrase} = 1;
#    $source{'00000000000'} = 1;
#    $source{'0000000000000'} = 1;

    my $tt;
    my $i = 0;
    my @result;
    my $result;
    foreach ( sort {$b cmp $a} keys %source ) {
	s/--+/_____/g;
	s/\Q$separator\E/__/g;
	$tt .= $_;
	if (++$i == 100) {
	    $i = 0;
	    $tt = decode('utf8', $tt) if $params->{lang_from} eq 'ru';
	    eval{
		$result = '';
#		while ( 100 != split $separator, $result ) {
		    $result = $self->t_ff( $tt, $params->{lang_to} );
		    $result =~ s/-\s+-/--/gsm;
		    $result =~ s/\=[\s\ ]+\=/==/g;
#		}
	    };
	    $result =~ s/[\s\n]*\Q$separator\E[\s\n]*/$separator/gsm;
#	    $result =~ s/-\s+-/--/gsm;
	    $result =~ s%mailto：%mailto:%g;
	    @result = ( @result, split $separator, $result );
	    $tt = '';
	} else {
	    $tt .= "\n\n$separator\n\n";
	}
    }

    $tt = decode('utf8', $tt) if $params->{lang_from} eq 'ru';
    eval{
	$result = '';
	$result = $self->t_ff( $tt, $params->{lang_to} );
	$result =~ s/-\s+-/--/gsm;
	$result =~ s/\=[\s\ ]+\=/==/g;
    };
    $result =~ s/[\s\n]*\Q$separator\E[\s\n]*/$separator/g;
    $result =~ s/-\s+-/--/g;
    $result =~ s/\=[\s\ ]+\=/==/g;
    $result =~ s%mailto：%mailto:%g;
    @result = ( @result, split $separator, $result );

    map { s/^(\s*\Q$separator\E)//; s/(\Q$separator\E\s*)$//; s/^(\s*<br>)//; s/(<br>\s*)$//; s/<br>/\n/g } @result;
    $source{$_} = shift @result foreach ( sort {$b cmp $a} keys %source );

$source{$check_phrase} =~ s/^\s*(.*)\s*$/$1/;
if ($source{$check_phrase} ne $check_phrase){
open TMP, '>>/tmp/ship.org.ua.tmp';
print TMP "\n?:".$_."\n".'!: '.$source{$_}."\n\n" foreach ( sort {$b cmp $a} keys %source );
close TMP;
#die();
return 0;
}

    foreach my $row (@$r) {
	my @new;
	foreach my $key (@keys) {
	    if ( $key eq 'lang' ) {
		push @new, $params->{lang_to};
		next;
	    } elsif ( ( grep { $_ eq $key } @{$params->{dnd}} ) ) {
		push @new, $row->{$key};
	    } else {
		push @new, $source{$row->{$key}};
	    }
	}
	my $q = '?,'x(@keys+0);
	$q =~ s/.$//;
	$db->sql( "INSERT INTO $params->{table} (".(join ( ',', @keys )).") VALUES ($q)", @new );
#open TMP, '>>/tmp/ship.org.ua.tmp';
#print TMP "INSERT INTO $params->{table} (".(join ( ',', @keys )).") VALUES ($q)"."\n";
#print TMP join ', ', @new;
#close TMP;
    }


    return $params->{table} . " : " . $params->{lang_to} . " : " . (0+@$r) . "<br />" . $tt;

    my @keys = grep { $_ ne $params->{id_main} } keys %{$r->[0]} ;
    my $tt;
    foreach my $row (@$r) {
        my @new;
	foreach my $key (@keys) {
	    $tt .= "$key : ".($row->{$key})." -- ";
	    my $tmp = ( grep { $_ eq $key } @{$params->{dnd}} )? 
		$row->{$key} : 
		    $self->translate(
		    $row->{$key}, 
		    $params->{lang_from}, 
		    $params->{lang_to}) ;
	    $tmp = $params->{lang_to} if $key eq 'lang';
	    push @new, $tmp;

	    open TMP, '>>/tmp/ship.org.ua.tmp';
	    print TMP "--\n".($row->{$key})."\n--\n";
	    print TMP "\n-------------------\n$tmp\n======================\n";
	    print TMP "sleep 300\n" if $row->{$key} && $row->{$key} !~ /^ +$/ && $tmp =~ /^ +$/;
	    close TMP;

	    sleep 300 if ( $row->{$key} && $row->{$key} !~ /^ +$/ && $tmp =~ /^ +$/ );
	    $tt .= "$tmp<BR>";
	}
	my $q = '?,'x(@keys+0);
	$q =~ s/.$//;
	$tt .= "<br>INSERT INTO $params->{table} (".(join ( ',', @keys )).") VALUES ($q)<br>".(join '<br>', @new);
	$db->sql( "INSERT INTO $params->{table} (".(join ( ',', @keys )).") VALUES ($q)", @new );
    }

    return $tt."$params->{table} - done";
}

use WWW::Mechanize::Firefox;

sub translate_hash {
#print "!!!!!!????????????????????????!!!!!!!!!!1";
    my $self = shift;
    my $lang_to = shift;
    my $lang_from = ($lang_to eq 'ua')? 'ru' : 'en';
    $_ = shift;
    my %source = %{$_};
    return \%source unless 0+keys %source;
    my $check_phrase = '01_2_34_56';
    $source{$check_phrase} = 1;
    my $tt;
    my $i = 0;
    my @result;
    my $result;
    foreach ( sort {$b cmp $a} keys %source ) {
	s/--+/_______/g;
	$tt .= $_;
	$i++;
	if (!($i % 50) || $i >= keys %source) {
	    $tt .= "\n:::\n";
	    $tt = decode('utf8', $tt) if $lang_from eq 'ru';
	    eval{
		$result = '';
		my $_ = ($i % 50)? $i % 50 : 50;
		while ( ($_+1) != split ":::", $result ) {
=c
		    print "\n".($_+1)."!=".(split "====", $result)."\n------------------\n";
		    print $tt."\n------------------\n";
		    my @result2 = split "====", $result;
		    print join '----', @result2;
		    print "\n------------------\n";
		    print $result."\n=====$lang_to======================------------------\n";
=cut
		    $result = $self->t_ff( $tt, $lang_to );
		    $result =~ s/-\s+-/--/smg;
		    $result =~ s/\=[\s\ ]+\=/==/g;
		}
	    };
	    $result =~ s/[\n\s]*:::[\n\s]*/:::/smg;
	    $result =~ s/-\s+-/--/smg;
	    $result =~ s/\=[\s\ ]+\=/==/g;
	    @result = ( @result, split ":::", $result );
open TMP, '>>/tmp/ship.org.ua.tmp';
print TMP 'xx2: '.$result;
close TMP;
	    $tt = '';
	} else {
	    $tt .= "\n:::\n";
	}
    }

    map { s/^(\s*:::)//; s/(:::\s*)$//; s/^(\s*<br>)//; s/(<br>\s*)$//; s/<br>/\n/g } @result;
    $source{$_} = shift @result foreach ( sort {$b cmp $a} keys %source );
    return 0 if $source{$check_phrase} ne $check_phrase;
    delete $source{$check_phrase};
    return \%source;
}

sub translate_ff {
#    my ( $t, $from, $to ) = @_;
#    $from = 'auto' unless $from;
    my ( $t, $to ) = @_;
#    my $from = ($to eq 'ua' && $t=~/а-я/)? 'ru' : 'auto';
    my $from = 'auto';
#    my $from = 'en';

$_=$to;
    s/ua/uk/;
    s/gr/el/;
    s/jp/ja/;
    s/ch/zh-CN/;
    s/il/iw/;
$to=$_;

    my $mech = WWW::Mechanize::Firefox->new( );

    $mech->get("http://translate.google.com/?hl=ru&tab=TT#$from|$to|");
#    sleep 2;

    $mech->value( text => $t );
#    sleep 1;
#
#$t =~ s/[\"\']/&amp;/g;
$t =~ s/\r//smg;
#$t =~ s/\n/ \\n /smg;
#$t =~ s/\n/ nnn /smg;
#$t = 'дубликат #3019,#3020,#3037.\n\n==\nПредлагаем строительство барж-площадок.\nДлинна габаритная 96,9 м. Ширина габаритная 15,8 м. Осадка с грузом 3,6 м. Класс РРР О(М). Грузоподъемность 3000-3200 DWT.Срок передачи заказчику первой баржи – июль 2012.\nПри желании заказчика класс О может быть изменен на класс М (с уменьшением грузоподъёмности на 10—15%). Кроме того, возможна установка кормовых упоров для толкания. Расчетный срок эксплуатации 20 лет, т.е. равен 4 периодам между классификационными освидетельствованиями, включая первоначальное, с возможным увеличением по истечению расчетного, при специальном рассмотрении РРР.\nВ случае заинтересованности нашим предложением, готовы дать более подробные описания и характеристики данного проекта.\nТак же можем предложить строительство барж 1000-1300 тонн.\nНадеемся на взаимовыгодное сотрудничество.\n==\nдубликат #3019,#3020,#3037\n==\nПредлагаем строительство барж-площадок\n==';

#$mech->eval_in_page('src=document.getElementById("source");src.focus();src.select();src.value="'.$t.'"');

    $mech->submit_form( with_fields => { text=>$t, sl=>'auto', tl=>$to } ); 
#    $mech->submit_form( with_fields => { text=>$t } ); 
#    sleep 2;

    for ( my $i = 1; $i<=10; $i++ ) {
	$_ =  $mech->content;
	last if m%id="?result_box"?.*?>(.*?)</div>% && $1 ne '</span>';
	sleep 1;
	if ( $i == 3 ){
	    $mech->submit_form( with_fields => { text => $t, sl=>'auto', tl=>$to } ); 
	}
    }
    my  $content = ( m%id="result_box".*?>(.*?)</div>% )? $1 : $t;

    $content =~ s%</span>%%g;
    $content =~ s%<span( (title|class)=".*?")?>%%g;
    $content =~ s%<br> -=-%<br>-=-%g;
#    $content =~ s%-\ =\ -%-=-%g;
#    $content =~ s%\ *\\\ *n\ *%\n%gi;
#    $content =~ s%\ *nnn\ *%\n%gi;
    return $content;
}

sub t_ff {
print "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    my $self = shift;
    my $text = shift;
    my ( $from, $to ) = @_;
    $_ = $text;
    #get words between tags
    s/<.*?>/-=-/g;
    my %words = map { s/^\s+//s; s/\s+$//s; $_ => 1 } grep { $_ !~ /^[\s\d\?\.\,]*$/s } split '-=-', $_;
    my $source = join "\n-=-\n", keys %words;
open TMP, '>>/tmp/ship.org.ua.tmp';
print TMP "\n-=-=-=-=-==-=-=-=-=-=-=-\n".$source."\n-=-=-=-=-==-=-=-=-=-=-=-\n";
close TMP;
    my $result = translate_ff ( $source, $from, $to );
open TMP, '>>/tmp/ship.org.ua.tmp';
print TMP "\n-=-=-=-=-==-=-=-=-=-=-=-\n".$result."\n-=-=-=-=-==-=-=-=-=-=-=-\n";
close TMP;

    my @s = split "\n-=-\n", $source;
####
    $result =~ s%\ *-\ *=\ *-%-=-%g;
    $result =~ s%\ *\<br\>\ *%<br>%g;
####
open TMP, '>>/tmp/ship.org.ua.tmp';
print TMP "$result\n";
close TMP;
#    my @r = split "<br>-=-<br>", $result;
    my @r = split "-=-", $result;
    foreach ( @s ) {
	my $r = shift @r;
	$text =~ s/\Q$_\E/$r/g;
    }
    return $text;
}
=c
=cut

1;
