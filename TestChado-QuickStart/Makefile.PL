use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'TestChado::QuickStart',
    AUTHOR              => q{Siddhartha Basu <sidd.basu@gmail.com>},
    VERSION_FROM        => 'lib/TestChado/QuickStart.pm',
    ABSTRACT_FROM       => 'lib/TestChado/QuickStart.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::Chado' => '1.0.0'
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'TestChado-QuickStart-*' },
);
