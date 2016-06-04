use utf8;
package Podsearch::Schema::Result::Module;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("modules");

__PACKAGE__->add_columns(
    "id",
    { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    "name",
    { data_type => "text", is_nullable => 0, pgfulltext => 'A' },
    "version",
    { data_type => "text", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many(
    pod_sections =>
    'Podsearch::Schema::Result::Pod',
    'module_id',
);

1;
