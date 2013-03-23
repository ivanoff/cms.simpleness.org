package CONFIG;

use strict;
use warnings;
use Exporter;

our ( @ISA, @EXPORT );
@ISA = qw( Exporter );
@EXPORT = qw( $CONFIG $CONFIG_TEMPLATE $CONFIG_IMAGES );

our $CONFIG = { 

        modules_path       => '../modules',
        config_files_path  => '../modules/admin/config',

        site               => 'admin.clear',
        email              => '2@ivanoff.org.ua',

# DB section

        db_type            => 'mysql',
        db_host            => 'localhost',
        db_dbname          => 'clear',
        db_user            => 'clear',
        db_password        => 'clear',

# Sessions dirs section

        session_dir        => '../tmp/session',
        session_expires    => '+1h',

# Cache dirs section

        cache              => 1,
        cache_time         => 259200,
        cache_dir          => '../tmp/cache',

# Language section

        default_language   => 'en',
        languages          => [ qw( en ru ua fr de es it gr ch jp tr ar fa il pl lv et lt nl bg ro da ko pt ) ],

        languages_t        => { en=>'english language', ru=>'русский язык', ua=>'українська мова', fr=>'la langue française', 
                     de=>'deutsche sprache', es=>'español', it=>'lingua italiana', gr=>'ελληνική γλώσσα', ch=>'汉语', 
                     jp=>'日本語', tr=>'Türk dili', ar=>'اللغة العربية', fa=>'زبان فارسی', il=>'עִבְרִית', 
                     pl=>'język polski', lv=>'latviešu valoda', et=>'eesti keel', lt=>'Lietùvių kalbà', 
                     nl=>'de Nederlandse taal', bg=>'Български език', ro=>'limba română', da=>'dansk', 
                     ko=>'한국어', pt=>'língua portuguesa', },
        languages_dont_translate => {
                     ru => '2@ivanoff.org.ua',
                    },
        phrases_dont_translate => [
                     'Simpleness CMS', 'cms.simpleness.org', 'simpleness.org',
                    ],

        languages_cache    => 1,
        languages_cache_path => '../modules/admin/config/lang/cache',

# Error config section

        show_errors        => 0,
        log_error          => '../log/error.log',
        log_sql            => '../log/clear.sql',

};

# Images section

our $CONFIG_IMAGES = {
        PATH    => 'images/gallery/',
        SIZE    => ['174x174', '640x480'],
};

# Template toolkit section

our $CONFIG_TEMPLATE = {
        INCLUDE_PATH      => '../template',  # or list ref
        POST_CHOMP        => 1,              # cleanup whitespace 
        PRE_PROCESS       => '',             # prefix each template
        EVAL_PERL         => 1,              # evaluate Perl code blocks
#        INTERPOLATE       => 1,             # expand "$var" in plain text
#        DEBUG             => 1,
};

1;
