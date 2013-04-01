#!/usr/bin/perl

use strict;
use warnings;

use lib '..';

use Test::More tests => 51;

require_ok( 'MAIN' );
use MAIN;
require_ok( 'TRANSLATE' );

is ( lang('default'), 'ru', "Default language is ru" );

my $t = new TRANSLATE( lang('default') );

isa_ok( $t, 'TRANSLATE' );

#$t->{'cache'} = 0;
#is( $t->_translate('О системе blah cool', 'ru', 'en'), 'привет! Как поживаешь?', '_translate simple en->ru' );
#die();
#use DATABASE;
#our $db = DATABASE->new;
#my $r = $t->_lang_checking ( { table=>'base_content', id=>'content_page', id_main=>'content_id', lang_from=>'ru', lang_to=>'en', dnd=>['user_id', 'content_date_from', 'content_place', ] } );

## dictianary
is ( ref($t->{'words'}), 'HASH' , "words is HASH");

is( $t->{'words'}{'Yes'}, 'Да', "Yes is Да" );
is( $t->{'words'}{'No'}, 'Нет', "No is Нет" );
is( $t->{'words'}{'January'}, 'январь', "January is январь" );
is( $t->{'words'}{'NOTRANSLATE'}, undef, '$t->{"words"}{"NOTRANSLATE"} is undef' );

is( $t->t('Yes'), 'Да', '$t->t("Yes") is Да' );
is( $t->t('No'), 'Нет', '$t->t("No") is  Нет' );
is( $t->t('January'), 'январь', '$t->t("January") is январь' );
is( $t->t('NOTRANSLATE'), 'NOTRANSLATE', '$t->t("NOTRANSLATE") is NOTRANSLATE' );

## replace
isa_ok( $t, 'TRANSLATE', '_replace_by_hash' );
is( $t->_replace_by_hash('aab baabc, c', {'aa'=>2, 'baab'=>1, 'c'=>5}), '2b 15, 5', '_replace_by_hash string english' );
is( $t->_replace_by_hash('(привет!) как дела?', {'привет'=>'hi', 'как дела'=>'how are you',}), '(hi!) how are you?', '_replace_by_hash russian to english' );
is( $t->_replace_by_hash('hi! .+ how are you?', {'hi'=>'привет', 'how are you'=>'как дела',}), 'привет! .+ как дела?', '_replace_by_hash english to russian' );

## translate simple
isa_ok( $t, 'TRANSLATE', '_translate_simple' );
is( $t->_translate_simple( "Hello World", 'en', 'ru' ), 
                    "Привет мир", '_translate( "Hello World", "en", "ru" )' );
is( $t->_translate_simple( "Hello! How are you? Please note that these instructions are not valid for WordPress.com users.", 'en', 'ru' ),
                    "Здравствуйте! Как поживаешь? Пожалуйста, обратите внимание, что эти указания не являются действительными для пользователей WordPress.com.",
                     '_translate "Hello! How are you..." ,"en", "ru"');

is( $t->_translate_simple( "Привет мир", 'ru', 'en' ), 
                    "Hello world", '_translate( "Привет мир", "ru", "en" )' );

is( $t->_translate_simple( "Hello World", 'en', 'en' ), 
                    "Hello World", '_translate( "Hello World", "en", "en" )' );
is( $t->_translate_simple( "123", 'en', 'ru' ), 
                    "123", '_translate( "123", "en", "ru" )' );

## words between tags
isa_ok( $t, 'TRANSLATE', '_words_between_tags' );
my $words = $t->_words_between_tags("Hello, World!");
is ( ref($words), 'HASH' , "_words_between_tags result is HASH");
ok ( keys %$words == 1, "1 key found" );
ok ( $words->{'Hello, World!'}, "key1: 'Hello, World!' was found");

$words = $t->_words_between_tags("<i>Hello, <b>World!</b></i>");
is ( ref($words), 'HASH' , "_words_between_tags result is HASH");
ok ( keys %$words == 2, "2 keys found" );
ok ( $words->{'Hello,'}, "key1: 'Hello,' was found");
ok ( $words->{'World!'}, "key2: 'World!' was found");

## translate hash
isa_ok( $t, 'TRANSLATE', '_translate_hash' );
$words = $t->_translate_hash($words, "en", "ru");
is ( ref($words), 'HASH' , "_translate_hash result is HASH");
ok ( keys %$words == 2, "2 keys found" );
is ( $words->{'Hello,'}, "Здравствуй,", "'Hello,' is 'Здравствуй,'");
is ( $words->{'World!'}, "Мир!", "'World!' is 'Мир!'");

## translate
isa_ok( $t, 'TRANSLATE', '_translate' );
is( $t->_translate('hi! how are you?', 'en', 'ru'), 'привет! Как поживаешь?', '_translate simple en->ru' );
is( $t->_translate('привет! как дела?', 'ru', 'en'), 'Hello! how are you?', '_translate simple ru->en' );
is( $t->_translate('hi! <i>how <b>are</b> you</i>?', 'en', 'ru'), 'привет! <i>как <b>есть</b> Вы</i>?', '_translate html en->ru' );
is( $t->_translate('<h1>привет! <b>как</b> дела?</h1>', 'ru', 'en'), '<h1>Hello! <b>as</b> are you?</h1>', '_translate html ru->en' );

is( $t->_translate('Perl 5.6 and earlier used a quicksort algorithm to implement sort. That algorithm was not stable, so could go quadratic. (A stable sort preserves the input order of elements that compare equal. Although quicksort\'s run time is O(NlogN) when averaged over all arrays of length N, the time can be O(N**2), quadratic behavior, for some inputs.) In 5.7, the quicksort implementation was replaced with a stable mergesort algorithm whose worst-case behavior is O(NlogN). But benchmarks indicated that for some inputs, on some platforms, the original quicksort was faster. 5.8 has a sort pragma for limited control of the sort. Its rather blunt control of the underlying algorithm may not persist into future Perls, but the ability to characterize the input or output in implementation independent ways quite probably will. See the sort pragma.', 'en', 'ru'), 
        'Perl 5.6 и более ранние версии использовали алгоритм быстрой сортировки для реализации подобного. Этот алгоритм не был стабильным, поэтому может пойти квадратичной. (Сортировке сохраняется порядок ввода элементов, которые считаются равными. Несмотря на время выполнения быстрой сортировки составляет O (NlogN), когда усредненная по всем массивов длины N, время может быть O (N ** 2), квадратичного поведения, для некоторых входов .) в 5,7, реализация быстрой сортировки был заменен на устойчивый алгоритм сортировки слиянием которых наихудшее поведение O (NlogN). Но тесты показали, что для некоторых входов, на некоторых платформах, оригинальные быстрой сортировки был быстрее. 5,8 есть своего рода директива для ограниченного контроля рода. Его довольно тупым контролем основной алгоритм не может сохраниться и в будущем Перлз, но способность характеризуют вход или выход в реализации независимыми способами, вполне вероятно, будет. См. рода Прагма.', 
        '_translate large en->ru' );

## translate cache
$t->{'cache'} = 1;
is( $t->_translate('hi! how are you?', 'en', 'ru'), 'привет! Как поживаешь?', '_translate cache simple en->ru' );
is( $t->_translate('привет! как дела?', 'ru', 'en'), 'Hello! how are you?', '_translate cache simple ru->en' );
is( $t->_translate('hi! <i>how <b>are</b> you</i>?', 'en', 'ru'), 'привет! <i>как <b>есть</b> Вы</i>?', '_translate cache html en->ru' );
is( $t->_translate('<h1>привет! <b>как</b> дела?</h1>', 'ru', 'en', 1), '<h1>Hello! <b>as</b> are you?</h1>', '_translate cache html ru->en' );
is( $t->_translate('Perl 5.6 and earlier used a quicksort algorithm to implement sort. That algorithm was not stable, so could go quadratic. (A stable sort preserves the input order of elements that compare equal. Although quicksort\'s run time is O(NlogN) when averaged over all arrays of length N, the time can be O(N**2), quadratic behavior, for some inputs.) In 5.7, the quicksort implementation was replaced with a stable mergesort algorithm whose worst-case behavior is O(NlogN). But benchmarks indicated that for some inputs, on some platforms, the original quicksort was faster. 5.8 has a sort pragma for limited control of the sort. Its rather blunt control of the underlying algorithm may not persist into future Perls, but the ability to characterize the input or output in implementation independent ways quite probably will. See the sort pragma.', 'en', 'ru', 1), 
        'Perl 5.6 и более ранние версии использовали алгоритм быстрой сортировки для реализации подобного. Этот алгоритм не был стабильным, поэтому может пойти квадратичной. (Сортировке сохраняется порядок ввода элементов, которые считаются равными. Несмотря на время выполнения быстрой сортировки составляет O (NlogN), когда усредненная по всем массивов длины N, время может быть O (N ** 2), квадратичного поведения, для некоторых входов .) в 5,7, реализация быстрой сортировки был заменен на устойчивый алгоритм сортировки слиянием которых наихудшее поведение O (NlogN). Но тесты показали, что для некоторых входов, на некоторых платформах, оригинальные быстрой сортировки был быстрее. 5,8 есть своего рода директива для ограниченного контроля рода. Его довольно тупым контролем основной алгоритм не может сохраниться и в будущем Перлз, но способность характеризуют вход или выход в реализации независимыми способами, вполне вероятно, будет. См. рода Прагма.', 
        '_translate cache large en->ru' );

my $cache_file = $main::CONFIG->{languages_cache_path}.'/en-ru.pl';
ok ( -f $cache_file, 'cache language file en-ru' );
my $ref = eval { local $SIG{__DIE__}; do $cache_file };
is( $ref->{'hi! how are you?'}, 'привет! Как поживаешь?', 'cache en-ru' );

my $cache_file = $main::CONFIG->{languages_cache_path}.'/ru-en.pl';
ok ( -f $cache_file, 'cache language file ru-en' );
$ref = eval { local $SIG{__DIE__}; do $cache_file };
is( $ref->{'привет! как дела?'}, 'Hello! how are you?', 'cache ru-en' );

