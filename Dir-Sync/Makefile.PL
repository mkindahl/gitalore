use 5.008004;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Dir::GitSync',
    VERSION_FROM     => 'lib/Dir/GitSync.pm',
    ABSTRACT         => 'Dir::GitSync - automaticall sync repositories',
    AUTHOR           => 'Mats Kindahl',
    LICENSE          => 'apache_2_0',
    MIN_PERL_VERSION => '5.008004',
    EXE_FILES        => ['script/mk-sync-dir'],
    PREREQ_PM        => {
        'strict'         => 0,
        'warnings'       => 0,
        'Git'            => '0.42',
        'Net::Domain'    => '3.15',
        'Text::Wrap'     => '2021.0814',
        'File::Basename' => '2.85',
    },
    (
        eval { ExtUtils::MakeMaker->VERSION(6.46) }
        ? (
            META_MERGE => {
                'meta-spec' => { version => 2 },
                resources   => {
                    repository => {
                        type => 'git',
                        url  => 'https://github.com/mkindahl/dir-sync.git',
                        web  => 'https://github.com/mkindahl/dir-sync',
                    },
                }
            }
          )
        : ()
    ),
);
