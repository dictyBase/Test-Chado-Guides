use Test::More qw/no_plan/;
use Test::Mojo;
use Test::Chado;
use Test::Chado::Common;
use Module::Load;
use FindBin qw($Bin);

load "$Bin/../app.pl";

my $schema = chado_schema( load_fixture => 1 );
my $t = Test::Mojo->new;
$t->app->schema($schema);

my $post = $t->post_ok(
    '/cvterms.json' => json => {
        namespace => 'test-chado-mojoapp',
        id        => 'TC:000001',
        name      => 'test chado rocks'
    },
    "it should post the new cvterm"
);
$post->status_is( 201, "should get the correct response" );
$post->header_is(
    Location => "/cvterms/TC:000001.json",
    "should get the correct HTTP location header"
);
has_cvterm( $schema, "test chado rocks", "should have the new cvterm" );
has_dbxref( $schema, "000001", "should have the new dbxref" );

$t->get_ok("/cvterms/TC:000001.json")->status_is(200)
    ->json_is( { name => "test chado rocks", id => "TC:000001" },
    "should get correct name and id" );

my $post2 = $t->post_ok(
    '/features.json' => json => {
        name     => 'tcpl',
        type     => 'gene',
        organism => 'human'
    },
    "it should post the new feature"
);
$post2->status_is( 201, "should get the correct response" );
$post2->header_is(
    Location => "/features/tcpl.json",
    "should get the correct HTTP location header"
);
has_feature( $schema, 'tcpl', 'should have the new feature in database' );

my $post3 = $t->post_ok(
    '/features.json' => json => {
        name     => 'panda',
        type     => 'contig',
        organism => 'human',
        start    => 48,
        end      => 500
    },
    "it should post the new feature with featureloc"
);
$post3->status_is( 201, "should get the correct response" );
$post3->header_is(
    Location => "/features/panda.json",
    "should get the correct HTTP location header"
);
has_feature( $schema, 'panda', 'should have the new feature in database' );
has_featureloc( $schema, 'panda',
    'should have the new feature with location in database' );
