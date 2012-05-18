use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile (
    NAME => 'File::Versions',
    VERSION_FROM => 'lib/File/Versions.pm',
    PREREQ_PM => {
        'autodie' => 0,
        'List::Util' => 0,
        'Test::More' => 0,
    },
);
