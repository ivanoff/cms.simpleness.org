package CONFIG;

use strict;
use warnings;
use Exporter;

our ( @ISA, @EXPORT );
@ISA = qw( Exporter );
@EXPORT = qw( $CONFIG $CONFIG_TEMPLATE $CONFIG_IMAGES );

our $CONFIG = { 

	modules_path	=> '../modules',
	config_path	=> '../modules/admin/config',

        site 		=> 'admin.clear',
        email 		=> 'email@your.site',

	show_errors	=> 1,
	log_error	=> 'log/error.log',
	log_sql		=> 'log/clear.sql',

	cache		=> 0,
	cache_time	=> 2592000,
	cache_dir	=> '../tmp',

        db_type 	=> 'mysql',
#        db_host 	=> 'localhost',
        db_database 	=> 'clear',
        db_user 	=> 'clear',
        db_password 	=> 'clear',

	default_language => 'ru',
	languages 	=> [ qw( en ru ua fr de es it gr ch jp tr ar fa il pl lv et lt nl bg ro da ko pt ) ],
	languages_t 	=> { en=>'english language', ru=>'русский язык', ua=>'українська мова', fr=>'la langue française', 
			     de=>'deutsche sprache', es=>'español', it=>'lingua italiana', gr=>'ελληνική γλώσσα', ch=>'汉语', 
			     jp=>'日本語', tr=>'Türk dili', ar=>'اللغة العربية', fa=>'زبان فارسی', il=>'עִבְרִית', 
			     pl=>'język polski', lv=>'latviešu valoda', et=>'eesti keel', lt=>'Lietùvių kalbà', 
			     nl=>'de Nederlandse taal', bg=>'Български език', ro=>'limba română', da=>'dansk', 
			     ko=>'한국어', pt=>'língua portuguesa', },
	
	show_env	=> 0,

};

our $CONFIG_IMAGES = {
        PATH	=> 'images/gallery/',
        SIZE	=> ['174x174', '640x480'],
};

our $CONFIG_TEMPLATE = {
        INCLUDE_PATH	=> 'template',  # or list ref
#        INTERPOLATE	=> 1,		# expand "$var" in plain text
        POST_CHOMP	=> 1,		# cleanup whitespace 
        PRE_PROCESS	=> '',		# prefix each template
        EVAL_PERL	=> 1,		# evaluate Perl code blocks
#        DEBUG		=> 1,
};

1;
