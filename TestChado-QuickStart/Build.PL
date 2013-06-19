    use strict;
    use warnings;
    use Module::Build;

    my %module_build_args = (
        "configure_requires" => { "Module::Build" => "0.3601" },
        "dist_abstract" =>
            "Unit testing for chado database modules and applications",
        "dist_author"  => ["Siddhartha Basu <biosidd\@gmail.com>"],
        "dist_name"    => "TestChado-QuickStart",
        "dist_version" => "1.0.0",
        "license"      => "perl",
        "module_name"  => "TestChado::QuickStart",
        "requires"     => { 'Test::Chado' => '1.0.0' }
    );

    my $build = Module::Build->new(%module_build_args);
    $build->create_build_script;
