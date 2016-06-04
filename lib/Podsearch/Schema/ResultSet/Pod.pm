use utf8;
package Podsearch::Schema::ResultSet::Pod;
use Moo;

extends 'DBIx::Class::ResultSet';
with 'Podsearch::Schema::Role::ResultSet::PgFulltext';

1;
