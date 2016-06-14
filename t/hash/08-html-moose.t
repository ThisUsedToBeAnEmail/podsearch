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
        get => 7,
        identifier => 'head1',
        html_title => '<h1>BUILDING CLASSES WITH MOOSE</h1>',
        html_content => q{<div><p>Moose makes every attempt to provide as much convenience as possible during class construction/definition, but still stay out of your way if you want it to. Here are a few items to note when building classes with Moose.</p><p>When you <pre><span>use Moose</span></pre>, Moose will set the class's parent class to <a href="Moose::Object">Moose::Object</a>, <i>unless</i> the class using Moose already has a parent class. In addition, specifying a parent with <pre><span>extends</span></pre> will change the parent class.</p><p>Moose will also manage all attributes (including inherited ones) that are defined with <pre><span>has</span></pre>. And (assuming you call <pre><span>new</span></pre>, which is inherited from <a href="Moose::Object">Moose::Object</a>) this includes properly initializing all instance slots, setting defaults where appropriate, and performing any type constraint checking or coercion.</p></div>}
    }); 

};

done_testing();

sub test_value {
    my $args = shift;

    my $parser = Pod::Hashed->new();
    $parser->parse_from_file( 't/data/moose.pod' );

    my $values = $parser->get($args->{get});
    
    my @fields = qw(identifier html_content html_title);
    foreach my $field (@fields) {
        is($values->{$field}, $args->{$field}, "correct value for $field - get $args->{get}");
    }
}

1;
