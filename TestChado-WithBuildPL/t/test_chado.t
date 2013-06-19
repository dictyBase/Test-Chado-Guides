use Test::More qw/no_plan/;
use Test::Chado;
use Test::Chado::Common;



my $schema = chado_schema(load_fixture => 1);

has_cv($schema,'sequence', 'should have sequence cv namespace');

has_cvterm($schema,'gene', 'should have gene cvterm');
has_cvterm($schema,'polypeptide', 'should have polypeptide cvterm');
has_cvterm($schema,'part_of', 'should have part_of cvterm');

has_dbxref($schema,'SO:0000704', 'should have dbxref' );
has_dbxref($schema,'SO:0000253', 'should have tRNA dbxref' );

drop_schema();
