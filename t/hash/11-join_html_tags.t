#!perl -T

use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok( 'Pod::Hashed' );
}

subtest 'join html content - same element' => sub {
    plan tests => 13;
    test_join_html({
        element_args => {
            element_name => 'Para',
            text => 'join some text',
            html_content => '<div><p>this is a test - para'
        },
        expected_html => '<div><p>this is a test - para</p><p>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'item-text',
            text => 'join some text',
            html_content => '<div><h5>this is a test (item)'        
        },
        expected_html => '<div><h5>this is a test (item)</h5><h5>join some text'        
    });        
    test_join_html({
        element_args => {
            element_name => 'over-text',
            text => '- join some text',
            html_content => '<div><h5>this is a test - over'
        },
        expected_html => '<div><h5>this is a test - over</h5><h5>- join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'Verbatim',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - Verbatim -'        
        },
        expected_html => '<div><pre><div>this is a test - Verbatim -</div></pre><pre><div>join some text'        
    }); 
    test_join_html({
        element_args => {
            element_name => 'Data',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - Data -'
        },
        expected_html => '<div><pre><div>this is a test - Data -</div></pre><pre><div>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'C',
            text => 'join some text',
            html_content => '<div><pre><span>foreach $item ( @many_items )'        
        },
        expected_html => '<div><pre><span>foreach $item ( @many_items ) join some text'        
    });   
    test_join_html({
        element_args => {
            element_name => 'L',
            text => 'join some text',
            html_content => '<div><p><a>this is a test - Link -',
        },
        expected_html => '<div><p><a>this is a test - Link - join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'B',
            text => 'join some text',
            html_content => '<div><p><b>this is a test - bold -',
        },
        expected_html => '<div><p><b>this is a test - bold - join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'I',
            text => 'join some text',
            html_content => '<div><p><i>this is a test - itallic -',
        },
        expected_html => '<div><p><i>this is a test - itallic - join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'E',
            text => 'join some text',
            html_content => '<div><p><span>this is a test - < -',
        },
        expected_html => '<div><p><span>this is a test - < - join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'F',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test - filename -',
        },
        expected_html => '<div><pre><span>this is a test - filename - join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'S',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test - $x ? $y : $z -',
        },
        expected_html => '<div><pre><span>this is a test - $x ? $y : $z - join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'X',
            text => 'join some text',
            html_content => '<div><h5>this is a test - absolutizing relative URLs -',
        },
        expected_html => '<div><h5>this is a test - absolutizing relative URLs -</h5><h5>join some text'
    });
};

done_testing();

sub test_join_html {
    my $args = shift;

    my $parser = Pod::Hashed->new();
    my $element_name = $args->{element_args}{element_name};
    my $tags = $parser->content_elements->{$element_name}{tags};
    $parser->html_end_tags([{ tags => $tags, element => $element_name }]) unless $args->{no_tags};
    $args->{element_args}{tags} = $tags;
    $args->{element_args}{embed} = $tags->{embed} ? 1 : undef;
    my $open_html = $parser->_join_html_tags($args->{element_args});
    is($open_html, $args->{expected_html}, 
        "_close_html_tags for $element_name - $args->{expected_html}");
}
1;
