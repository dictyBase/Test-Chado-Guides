use strict;
use Test::More qw/no_plan/;
use Test::Chado;
use Test::Chado::Common;


my $schema = chado_schema( load_fixture => 1 );
create_test_gene( $schema, $_ ) for qw/caboose tucker/;

has_feature $schema, $_, "should have gene $_" for qw/caboose tucker/;

create_test_floc(
    $schema,
    [   { name => 'jorn', start => 10, end => 50 },
        { name => 'todd', start => 60, end => 100 }
    ]
);

has_featureloc $schema, $_, "should have featureloc for gene $_"
    for qw/todd jorn/;

drop_schema();

sub create_test_gene {
    my ( $schema, $gene_name ) = @_;
    my $organism = $schema->resultset('Organism')
        ->search( { common_name => 'human' }, { rows => 1 } )->first;
    $schema->resultset('Feature')->create(
        {   uniquename  => $gene_name,
            organism_id => $organism->organism_id,
            type_id =>
                $schema->resultset('Cvterm')->find( { name => 'gene' } )
                ->cvterm_id
        }
    );
}

sub create_test_floc {
    my ( $schema, $locations ) = @_;

    my $organism = $schema->resultset('Organism')
        ->search( { common_name => 'human' }, { rows => 1 } )->first;

    for my $data (@$locations) {
        $schema->resultset('Feature')->create(
            {   uniquename  => $data->{name},
                organism_id => $organism->organism_id,
                type_id =>
                    $schema->resultset('Cvterm')->find( { name => 'gene' } )
                    ->cvterm_id,
                featureloc_features => [
                    {   fmin => $data->{start},
                        fmax => $data->{end}
                    }
                ]
            }
        );
    }
}
