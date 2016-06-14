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
        html_content => '<div><p>perlfaq3 - Programming Tools ($Revision: 1.38 $, $Date: 1999/05/23 16:08:30 $)</p></div>',
        html_title => '<h1>NAME</h1>',
    });
    test_value({
        get => 9,
        identifier => 'head2',
        html_title => '<h1>Is there a ctags for Perl?</h1>',
        html_content => "<div><p>There's a simple one at http://www.perl.com/CPAN/authors/id/TOMC/scripts/ptags.gz which may do the trick. And if not, it's easy to hack into what you want.</p></div>",
    });
    test_value({
        get => 13,
        identifier => 'head2',
        html_title => '<h1>How can I use curses with Perl?</h1>',
        html_content => "<div><p>The Curses module from CPAN provides a dynamically loadable object module interface to a curses library. A small demo can be found at the directory http://www.perl.com/CPAN/authors/Tom_Christiansen/scripts/rep; this program repeats a command and updates the screen as needed, rendering <b>rep ps axu</b> similar to <b>top</b>.</p></div>",
    });
};

done_testing();

sub test_value {
    my $args = shift;

    my $parser = Pod::Hashed->new();
    $parser->parse_file( 't/data/perlfaq.pod' );

    my $values = $parser->get($args->{get});
    
    my @fields = qw(identifier html_content html_title);
    foreach my $field (@fields) {
        is($values->{$field}, $args->{$field}, "correct value for $field - get $args->{get}");
    }
}

1;
