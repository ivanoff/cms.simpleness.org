package CONFIG;

use strict;
use warnings;
use Exporter;

our ( @ISA, @EXPORT );
@ISA = qw( Exporter );
@EXPORT = qw( $CONFIG $CONFIG_TEMPLATE $CONFIG_IMAGES );

our $CONFIG = { 

        site               => 'admin.clear',
        email              => '2@ivanoff.org.ua',

        modules_extension  => 'hash',
        modules_path       => '../modules',
        config_files_path  => '../modules/admin/config',

# DATABASE
        db_type            => 'mysql',          # mysql or Pg
        db_host            => 'localhost',
        db_dbname          => 'clear',
        db_user            => 'clear',
        db_password        => 'clear',

# SESSIONS
        session_dir        => '../tmp/session', # path to store sesions
        session_expires    => 60*60*3,          # session expires ( in seconds )

# CACHE
        cache => {
            memcached => {                  # memcached parameters
                servers => [ '127.0.0.1:11211' ], 
                expire  => 60*60*24*29,     # Expiration times can be set from 0, meaning "never expire", to 30 days. 
                                            # Any time higher than 30 days is interpreted as a unix timestamp date.
            },
#            file      => {                   # cache content to files with plain name
#                dir     => '../tmp/mirror',  # path to store file cache
#                expire  => 60*60*24*31,      # cache expire time (in seconds )
#                ext     => ".cache",         # additional file extention
#            },
#            file_md5  => {                   # cache content to files with md5 name
#                dir     => '../tmp/cache',   # path to store file cache
#                expire  => 60*60*24*31,      # cache expire time (in seconds )
#            },
        },

# LANGUAGE
        default_language   => 'en',
        languages          => [ qw( en ru ua fr de es it gr ch jp tr ar fa il pl lv et lt nl bg ro da ko pt ) ],

        languages_t        => { en=>'english language', ru=>'русский язык', ua=>'українська мова', fr=>'la langue française', 
                     de=>'deutsche sprache', es=>'español', it=>'lingua italiana', gr=>'ελληνική γλώσσα', ch=>'汉语', 
                     jp=>'日本語', tr=>'Türk dili', ar=>'اللغة العربية', fa=>'زبان فارسی', il=>'עִבְרִית', 
                     pl=>'język polski', lv=>'latviešu valoda', et=>'eesti keel', lt=>'Lietùvių kalbà', 
                     nl=>'de Nederlandse taal', bg=>'Български език', ro=>'limba română', da=>'dansk', 
                     ko=>'한국어', pt=>'língua portuguesa', },
        languages_dont_translate => {
#                     ru => '2@ivanoff.org.ua',
#                     ua => '', #default email
#                     en => '',
                    },
        phrases_dont_translate => [
                     'Simpleness CMS', 'cms.simpleness.org', 'simpleness.org',
                    ],

        languages_cache    => 1,
        languages_cache_path => '../modules/admin/config/lang/cache',

# ERROR CONFIG
        show_errors        => 1,
        log_error          => '../log/error.log',
        log_sql            => '../log/clear.sql',

# Automatically updates section
# frequency parameter regexp string 'YYYY-MM-DD;HH:MM:SS;DOW;DOY'
        update_automatically    => 1,
        update_log_file         => '../log/upgate.log',
        update_rules_file       => '../modules/admin/config/update.pl',
        update_rules_timeout    => 60*60*24,
        update_frequency_regexp => qr/;6;/,  #every friday

# DEMO
        demo_enabled    => 0,   # enable demo mode ( login: demo/demo )

# COMMENTS
        comments_enabled => 0,  # show comments

};

# Images section

our $CONFIG_IMAGES = {
        PATH    => 'images/gallery/',
        SIZE    => ['174x174', '640x480'],
};

# Template toolkit section

our $CONFIG_TEMPLATE = {
        INCLUDE_PATH    => '../template',  # or list ref
        POST_CHOMP      => 1,              # cleanup whitespace 
        PRE_PROCESS     => '',             # prefix each template
        EVAL_PERL       => 1,              # evaluate Perl code blocks
#        INTERPOLATE     => 1,             # expand "$var" in plain text
#        DEBUG           => 1,
        RECURSION       => 1,
        POST_CHOMP      => 1,
};

1;
