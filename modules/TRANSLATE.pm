#!/usr/bin/perl

package TRANSLATE;

use strict;

use utf8;
use Encode;
use WWW::Mechanize;

sub new {
    my ($class, $lang) = @_;
    my $self = {};

    $lang='en' unless $lang;
    $self->{'language'} = $lang;
    $self->{'cache'} = $main::CONFIG->{languages_cache};
    $self->{'no_lang_cache'} = 0;

    my $lang_file = $main::CONFIG->{config_files_path}.'/lang/'.$lang.'.pl';
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
#        $word = $self->new_word($word);
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
    my ($self, $file_name, $ref) = @_;
    $file_name = $self->{'language_file'} unless $file_name;
    $ref = $self->{'words'} unless $ref;

    open FILE, '>:utf8', $file_name;
    print FILE "{\n";
    print FILE "\t''\t=> ' ',\n" unless $ref->{''};
    foreach my $key (sort {uc($a) cmp uc($b)} keys %{$ref}) {
        my $key_c = $key;
        $key_c =~ s/\'/\\\'/g;
        $ref->{$key} =~ s/\'/\\\'/g;
        utf8::decode( $ref->{$key} );
        utf8::decode( $key_c );
        print FILE "\t'$key_c'\t=> '".$ref->{$key}."',\n";
    }
    print FILE "};";
    close FILE;
}

#translate simple short text
sub translate_simple {
    my $self = shift;
    my ( $text, $from, $to ) = @_;
    return $text if ($from eq $to);
    return $text if $text =~ /^[\s\d]*$/;
    return $text if $text =~ /^\s*\{[\w\/]+\}\s*$/;
    $text =~ s/&#39;/'/gsm;
    $text =~ s/&quot;/\"/gsm;
    $to =~ s/ua/uk/;
    $to =~ s/gr/el/;
    $to =~ s/jp/ja/;
    $to =~ s/ch/zh-CN/;
    $to =~ s/il/iw/;
    my $mech = WWW::Mechanize->new();
    eval {
        $mech->get( "http://translate.google.com/?tl=$to&fl=$from&q=$text" );
    };
    return $text if $@;
    my $_ = encode 'utf8', $mech->content;
    return $text unless ( (/<span.*?backgroundColor='#ebeff9'.*?>(.*?)<\/span>/) );
    $_ = join '', (/<span.*?backgroundColor='#ebeff9'.*?>(.*?)<\/span>/g);
    return $_;
}

#returns words between tags
sub words_between_tags {
    my ( $self, $_ ) = @_;
    s/<pre>.*?<\/pre>/-=-/smig;
    s/<.*?>/-=-/g;
    my %words = map { s/^\s+//s; s/\s+$//s; $_ => 1 } grep { $_ !~ /^[\s\d\?\.\,]*$/s } split '-=-', $_;
    return \%words;
}

#replace all words from key to value in text
sub replace_by_hash {
    my ( $self, $text, $hash ) = @_;
    foreach ( sort {length($b) cmp length($a)} keys %$hash ) {
        $text =~ s/\Q$_\E/$hash->{$_}/g;
    }
    return $text;
}

#translate hash
sub translate_hash {
    my ( $self, $words, $from, $to ) = @_;
    return $words if ( ref($words) ne 'HASH' );
    return $words if $from =~ /\./ || $to =~ /\./;
    my ( $cache_file, $ref );
    if ( $self->{'cache'} ) {
    ## restore cache lang
        $cache_file = $main::CONFIG->{languages_cache_path}.'/'.$from.'-'.$to.'.pl';
        $ref = eval { local $SIG{__DIE__}; do $cache_file } if -f $cache_file;
    }
    foreach (keys %$words) {
        next if defined $words->{$_} && $words->{$_} ne '1';
        $words->{$_} = ( $self->{'cache'} && !$self->{'no_lang_cache'} && $ref && $ref->{$_} )? $ref->{$_}
                        : $self->translate_simple( $_, $from, $to );
        $ref->{$_} = $words->{$_} if $self->{'cache'};
    }
    if ( $self->{'cache'} ) {
    ## save cache lang
        $self->save_lang( $cache_file, $ref );
    }
    return $words;
}

#translate text
#$text can be link to hash or any text
sub translate {
    my $self = shift;
    my ( $text, $from, $to ) = @_;
    if ( ref($text) eq 'HASH' ) {
        return $self->translate_hash( $text, $from, $to );
    }
    my $hash = $self->words_between_tags( $text );
    $hash = $self->translate_hash( $hash, $from, $to );
    return $self->replace_by_hash( $text, $hash );
}

sub dictionary_translate {
    my %words;
    foreach my $lang ( @{$main::CONFIG->{languages}} ) {
        my $ref = eval { local $SIG{__DIE__}; do $main::CONFIG->{config_files_path}.'/lang/'.$lang.'.pl' };
        $words{$_} = 1 foreach keys %$ref;
    }
    $words{$_} = 1 foreach ( @{$main::CONFIG->{phrases_dont_translate}} );

    foreach my $lang ( @{$main::CONFIG->{languages}} ) {
        my $translate;
        my $t = TRANSLATE->new($lang);
        foreach ( keys %words ) {
            next if /^\ *$/;
#            $translate->{$_}=1 if !$t->{words}{$_} || $t->{words}{$_} ~= /^\ *$/;
            $translate->{$_}=1 if !$t->{words}{$_};
        }
        if ($lang eq 'en') {
            $t->{'words'}{$_}=' ' foreach keys %$translate;
            $t->save_lang;
            next;
        }
        $translate = $t->translate($translate, 'en', $lang);
        $t->{'words'}{$_}=$translate->{$_} foreach keys %$translate;
        $t->save_lang;
    }
}

sub lang_checking {
    my ($self, $params) = @_;
    return 0 unless $params->{table} && $params->{id} && $params->{id_main};
    push @{$params->{dnd}}, $params->{id};

    $params->{lang_from} = $main::CONFIG->{default_language} unless $params->{lang_from};
    $params->{lang_to} = $self->{'language'} unless $params->{lang_to};

    my $db = $main::db;
    my $r = $db->sql("SELECT * FROM $params->{table} WHERE lang=? AND $params->{id} NOT IN 
                (SELECT $params->{id} FROM $params->{table} WHERE lang=?)", 
                $params->{lang_from}, $params->{lang_to});
    return "$params->{table} - nothing to do" unless @$r;
    
    my @keys = grep { $_ ne $params->{id_main} } keys %{$r->[0]};

    my $t = TRANSLATE->new($params->{lang_to});

    ## get text to translate in to refhash $source with translated text
    my $source;
    foreach my $row (@$r) {
        foreach my $key (@keys) {
            next if $key eq 'lang';
            next if ( grep { $_ eq $key } @{$params->{dnd}} );
            next if $source->{$row->{$key}};
            $source->{$row->{$key}} = $self->translate($row->{$key}, $params->{lang_from}, $params->{lang_to} );
            ##replace don't translate phrases
            foreach my $phrase ( @{$main::CONFIG->{phrases_dont_translate}} ) {
                my $_ = $t->t( $phrase );
                next unless $_;
                $_ = $phrase if /^\ *$/;
                $source->{$row->{$key}} =~ s/\Q$_\E/$phrase/g;
            }
        }
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
                push @new, $source->{$row->{$key}};
            }
        }
        my $q = '?,'x(@keys+0);
        $q =~ s/.$//;
        $db->sql( "INSERT INTO $params->{table} (".(join ( ',', @keys )).") VALUES ($q)", @new );
    }

    return $params->{table} . " : " . $params->{lang_to} . " : " . (0+@$r) . "<br />";

}

## send email to owners of languages_dont_translate
sub email_to_lang_owners {
return 0;
    my ($self, $url) = @_;
    my $lang_owner;
    foreach (keys %{$main::CONFIG->{languages_dont_translate}}) {
        push @{$lang_owner->{$main::CONFIG->{languages_dont_translate}{$_}}}, $_;
    }
    foreach (keys %{$lang_owner}){
        my $message;
        $main::template->process('messages/lang_owner_was_modyfied.tpl', 
                { %{$main::tt}, lang=>$lang_owner->{$_}, url=>$url, }, \$message );
        email ( { 
            To    => $_,
            Subject => "Page was modyfied",
                Message => $message,
            } );
    }
return 1;
}


sub renew_content {
    my ( $self, $params ) = @_;
=c
            if ( is_default_lang ) {
                my $x = '?,' x (keys %{$CONFIG->{languages_dont_translate}});
                $x =~ s/.$//;
                $x = "''" unless $x;
                sql( "DELETE FROM base_news WHERE news_key=? AND lang!=? AND lang NOT IN ($x)", 
                        $n->[0]{news_key}, lang('default'), keys %{$CONFIG->{languages_dont_translate}});
            }
=cut
    $_ = ( ref $params eq 'HASH' )? $params->{name} : $params;
    $params = {} if ref $params ne 'HASH';

    /^menu$/ && do {
        $params = { table=>'base_menu', id=>'menu_key', id_main=>'menu_id', dnd=>[ ], %$params };
    };

    foreach my $to ( @{$CONFIG->{languages}} ) {
        next if is_default_lang($to);
        $self->lang_checking ( { lang_from=>lang('default'), lang_to=>$to, %$params } );
    }
#    $main::t->email_to_lang_owners('/admin/menu') if is_default_lang;
    return 1;
}

1;
