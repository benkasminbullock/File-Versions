use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile (
    NAME => 'File::Versions',
    VERSION_FROM => 'lib/File/Versions.pm',
    PREREQ_PM => {
        'List::Util' => 0,
        'Test::More' => 0,
    },
);
