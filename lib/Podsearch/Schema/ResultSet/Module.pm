use utf8;
package Podsearch::Schema::ResultSet::Module;
use Moo;
use Try::Tiny;
use Carp qw(croak);
extends 'DBIx::Class::ResultSet';
with 'Podsearch::Schema::Role::ResultSet::PgFulltext';

use MetaCPAN::Client;
use Pod::Hashed;

sub generate_pod {
    my ($self, $release) = @_;
    
    my $mcpan = MetaCPAN::Client->new;
    my $provides = $mcpan->release($release)->provides;
    
    foreach my $name ( @{ $provides } ) {
        try {
            my $module = $mcpan->module($name);
            my $version = $module->version_numified;
            my @pod = _parse_module($module->pod('x-pod'));

            my $result = $self->single({
                name => $name
            });

            if ($result) {
                return "$name Pod already up to date" 
                    if $result->version <= $version; 
        
                $self->update_pod($result, @pod);
                $result->update({ version => $version });
                return "$name Pod has been updated";
            } else {
                $result = $self->create({ 
                    name => $name, 
                    version => $version 
                });

                $self->update_pod($result, @pod);
                return "$name Pod has been generated";
            }
        } catch {
            croak "Could not generate Pod for $name";
        }
    }
}

sub update_pod {
    my ($self, $result, @pod) = @_;

    my $order = 0;
    my $schema = $self->result_source->schema;
    foreach my $section (@pod) {
        $section->{module_id} = $result->id;
        
        my $result = $schema->resultset('Pod')
            ->update_or_create($section);
        
        $result->update({ default_order => $order++ });
    }
}

sub _parse_module {
    my ( $module ) = @_;

    my $parser = Pod::Hashed->new();
    $parser->parse_string_document($module);
    return $parser->pod_aoh;
}

1;
