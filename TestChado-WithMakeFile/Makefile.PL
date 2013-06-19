use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'TestChado::WithMakeFile',
    AUTHOR              => q{Siddhartha Basu <sidd.basu@gmail.com>},
    VERSION_FROM        => 'lib/TestChado/WithMakeFile.pm',
    ABSTRACT_FROM       => 'lib/TestChado/WithMakeFile.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'TestChado-WithMakeFile-*' },
);
