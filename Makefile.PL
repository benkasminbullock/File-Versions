use strict;
use warnings;
use ExtUtils::MakeMaker;

my $repo = 'https://github.com/benkasminbullock/File-Versions';

WriteMakefile (
    NAME => 'File::Versions',
    VERSION_FROM => 'lib/File/Versions.pm',
    PREREQ_PM => {
        'List::Util' => 0,
        'Test::More' => 0,
    },
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
        },
    },
);
