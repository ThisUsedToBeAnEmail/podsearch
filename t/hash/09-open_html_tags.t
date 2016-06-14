#!perl -T

use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok( 'Pod::Hashed' );
}

subtest 'open html tags' => sub {
    plan tests => 13;
    test_open_html({
        element_args => {
            element_name => 'Para',
            text => 'this is a test - para',
        },
        expected_html => '<div><p>this is a test - para'
    });
    test_open_html({
        element_args => {
            element_name => 'item-text',
            text => 'this is a test - item',
        },
        expected_html => '<div><h5>this is a test - item'        
    });        
    test_open_html({
        element_args => {
            element_name => 'over-text',
            text => 'this is a test - over',
        },
        expected_html => '<div><h5>this is a test - over'
    });
    test_open_html({
        element_args => {
            element_name => 'Verbatim',
            text => 'this is a test - Verbatim',
        },
        expected_html => '<div><pre><div>this is a test - Verbatim'        
    }); 
    test_open_html({
        element_args => {
            element_name => 'Data',
            text => 'this is a test - Data',
        },
        expected_html => '<div><pre><div>this is a test - Data'
    });
    test_open_html({
        element_args => {
            element_name => 'C',
            text => 'foreach $item ( @many_items )',
        },
        expected_html => '<div><pre><span>foreach $item ( @many_items )'        
    });   
    test_open_html({
        element_args => {
            element_name => 'L',
            text => 'this is a test - Link',
        },
        expected_html => '<div><a>this is a test - Link'
    });
    test_open_html({
        element_args => {
            element_name => 'B',
            text => 'this is a test - bold',
        },
        expected_html => '<div><b>this is a test - bold'        
    });
    test_open_html({
        element_args => {
            element_name => 'I',
            text => 'this is a test - itallic',
        },
        expected_html => '<div><i>this is a test - itallic'
    });
    test_open_html({
        element_args => {
            element_name => 'E',
            text => 'this is a test - <',
        },
        expected_html => '<div><span>this is a test - <'        
    });
    test_open_html({
        element_args => {
            element_name => 'F',
            text => 'this is a test - filename',
        },
        expected_html => '<div><pre><span>this is a test - filename'
    });
    test_open_html({
        element_args => {
            element_name => 'S',
            text => 'this is a test - $x ? $y : $z',
        },
        expected_html => '<div><pre><span>this is a test - $x ? $y : $z'        
    });
    test_open_html({
        element_args => {
            element_name => 'X',
            text => 'this is a test - absolutizing relative URLs',
        },
        expected_html => '<div><h5>this is a test - absolutizing relative URLs'
    });
};

done_testing();

sub test_open_html {
    my $args = shift;
    
    my $parser = Pod::Hashed->new();
    my $element_name = $args->{element_args}{element_name};
    $args->{element_args}{tags} = $parser->content_elements->{$element_name}{tags};
    my $open_html = $parser->_open_html_tags($args->{element_args});
    is($open_html, $args->{expected_html}, 
        "_open_html_tags for $element_name - $args->{expected_html}");
}

1;
