package Podsearch::Schema::Role::ResultSet::PgFulltext;

use Moo::Role;
use Carp qw(croak);

has normalisation_ops => (
    is => 'ro',
    lazy => 1,
    default => sub {
        return {
            log_length => 1,
            length  => 2,
            harmonic_distance => 4,
            unique_words => 8,
            log_uniquer_words => 16,
            rank => 32,
        };
    }
);

has column_spec => (
    is => 'ro',
    lazy => 1,
    builder => '_build_column_spec',
);

sub _build_column_spec {
    my ($self) = shift;
   
    my $columns = $self->result_source->columns_info;
    my @column_spec;
    foreach my $name (keys %{$columns}){
        if (my $weight = $columns->{$name}->{pgfulltext}) {
            push @column_spec, { name => $name, weight => $weight };
        }
    }

    croak "No pgfulltext column spec found in result class"
        unless @column_spec;

    return \@column_spec;
}

has ts_query => (
    is => 'rw',
    default => q{plainto_tsquery(?)},
);

has ts_vector => (
    is => 'ro',
    lazy => 1,
    builder => '_build_ts_vector',
);

sub _build_ts_vector {
    my $self = shift;
    
    my @vectors;
    foreach my $field (@{$self->column_spec}){
        push @vectors, sprintf(
            q{setweight(to_tsvector('english', coalesce("me"."%s", '')), '%s')},
            $field->{name},
            $field->{weight} || 'A',
        );
    }

    return sprintf('( %s )', join(' || ', @vectors));
}

sub pgfulltext_search {
    my ($self, $search_term, $args) = @_;
    
    $args ||= {};
    
    my $column_spec = $args->{column_spec} || $self->column_spec;
    my $ts_query = $self->ts_query;
    my $ts_vector = $self->ts_vector;
    
    my $normalisation = $args->{normalisation} 
        ? $self->_normalisation(0, $args)
        : 0;
    
    my $rank = [
        sprintf('ts_rank_cd(%s, %s, %s)', $ts_vector, $ts_query, $normalisation),
            [ ts_query => $search_term ],
    ];

    my %where = (
        -and => [
            \[ $ts_query . ' @@ ' . $ts_vector, [ ts_query => $search_term ] ]
        ],
    );

    my %attributes = (
        order_by => { -desc => \$rank },
    );

    return $self->search(\%where, \%attributes);
}

sub _normalisation {
    my ($self, $normalisation, $args) = @_;
    
    foreach my $normalise ( keys $self->normalisation_ops ) {
        if ( $args->{normalisation}->{$normalise} ) {
            $normalisation |= $self->normalisation_ops->{$normalise}
        }
    }
    return $normalisation;
}

1;
