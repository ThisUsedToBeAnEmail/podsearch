use utf8;
package Podsearch::Schema::Result::Pod;

use Moo;
use HTML::Escape qw/escape_html/;

extends 'DBIx::Class::Core';

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

has 'escaped_title' => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;

        my $title = $self->title;
        return escape_html($title);
    }
);

has 'escaped_content' => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;

        my $content = $self->content;
        return escape_html($content);
    }
);

1;
