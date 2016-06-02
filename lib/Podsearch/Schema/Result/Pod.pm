use utf8;
package Podsearch::Schema::Result::Pod;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("pod");

__PACKAGE__->add_columns(
    "id",
    { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    "module_id",
    { data_type => "integer" },
    "identifier",
    { data_type => "text", is_nullable => 0 },
    "title",
    { data_type => "text", is_nullable => 0 },
    "content",
    { data_type => "text", is_nullable => 1 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    "module",
    "Podsearch::Schema::Result::Pod",
    { id => "module_id" },
);

1;
