use Mojolicious::Lite;
use Mojo::Base -base;
use Bio::Chado::Schema;
use FindBin qw($Bin);
use File::Spec::Functions;

app->attr(
    schema => sub {
        my $dbname = catfile( $Bin, "db", "chado.sqlite" );
        return Bio::Chado::Schema->connect( "dbi:SQLite:dbname=$dbname", "",
            "" );
    }
);

post 'features' => [ format => [qw/json/] ] => sub {
    my $self   = shift;
    my $schema = app->schema;
    my $params = $self->req->json;
    for my $p (qw/name organism type/) {
        if ( not defined $params->{$p} ) {
            $self->res->message("Required parameter $p missing");
            $self->rendered(400);
            return;
        }
    }

    my $org_row
        = $schema->resultset('Organism')
        ->search( { common_name => $params->{organism} }, { rows => 1 } )
        ->single;
    my $feat_row = $schema->resultset('Feature')->create(
        {   name       => $params->{name},
            uniquename => $params->{name},
            type_id    => $schema->resultset('Cvterm')
                ->find( { name => $params->{type} } )->cvterm_id,
            organism_id => $org_row->organism_id
        }
    );
    if ( defined $params->{start} and defined $params->{end} ) {
        $feat_row->create_related( 'featureloc_features',
            { fmin => $params->{start}, fmax => $params->{end} } );
    }
    $self->res->headers->location( "/features/" . $params->{name} . ".json" );
    $self->rendered(201);

};

post '/cvterms' => [ format => [qw/json/] ] => sub {
    my $self   = shift;
    my $params = $self->req->json;
    for my $p (qw/namespace id name/) {
        if ( not defined $params->{$p} ) {
            $self->res->message("Required parameter $p missing");
            $self->rendered(400);
            return;
        }
    }
    my ( $db, $id ) = split /:/, $params->{id};
    my $schema     = app->schema;
    my $cvterm_row = $schema->resultset('Cvterm')->create(
        {   name  => $params->{name},
            cv_id => $schema->resultset('Cv')
                ->find_or_create( { name => $params->{namespace} } )->cv_id,
            dbxref => {
                accession => $id,
                db_id     => $schema->resultset('Db')
                    ->find_or_create( { name => $db } )->db_id
            }
        }
    );

    $self->res->headers->location( "/cvterms/" . $params->{id} . ".json" );
    $self->rendered(201);
};

get '/cvterms/:id' => [ format => [qw/json/] ] => sub {
    my $self   = shift;
    my $schema = app->schema;
    my ( $db, $id ) = split /:/, $self->stash('id');
    my $row = $schema->resultset('Dbxref')
        ->search( { accession => $id }, { rows => 1 } )->single;
    if ( !$row ) {
        $self->rendered(401);
        return;
    }
    $self->render(
        json => {
            name => $row->cvterm->name,
            id   => $self->stash("id")
        }
    );
};

app->start;
