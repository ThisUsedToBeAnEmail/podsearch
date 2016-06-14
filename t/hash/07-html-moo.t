#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN {
    use_ok( 'Pod::Hashed' ) || print "Bail out!\n";
}

subtest 'hash options' => sub {
     test_value({
        get => 0,
        identifier => 'head1',
        html_content => '<div><p>Moo - Minimalist Object Orientation (with Moose compatibility)</p></div>',
        html_title => '<h1>NAME</h1>',
    }); 
    test_value({
        get => 1,
        identifier => 'head1',
        html_title => '<h1>SYNOPSIS</h1>',
        html_content => q{<div><pre><div>  package Cat::Food;

  use Moo;
  use strictures 2;
  use namespace::clean;

  sub feed_lion {
    my $self = shift;
    my $amount = shift || 1;

    $self->pounds( $self->pounds - $amount );
  }

  has taste => (
    is => \'ro\',
  );

  has brand => (
    is  => \'ro\',
    isa => sub {
      die "Only SWEET-TREATZ supported!" unless $_[0] eq \'SWEET-TREATZ\'
    },
  );

  has pounds => (
    is  => \'rw\',
    isa => sub { die "$_[0] is too much cat food!" unless $_[0] < 15 },
  );

  1;</div></pre><p>And elsewhere:</p><pre><div>  my $full = Cat::Food->new(
      taste  => \'DELICIOUS.\',
      brand  => \'SWEET-TREATZ\',
      pounds => 10,
  );

  $full->feed_lion;

  say $full->pounds;</div></pre></div>},
    });
};

done_testing();

sub test_value {
    my $args = shift;

    my $parser = Pod::Hashed->new();
    $parser->parse_from_file( 't/data/moo.pod' );

    my $values = $parser->get($args->{get});
    
    my @fields = qw(identifier html_content html_title);
    foreach my $field (@fields) {
        is($values->{$field}, $args->{$field}, "correct value for $field - get $args->{get}");
    }
}

1;
