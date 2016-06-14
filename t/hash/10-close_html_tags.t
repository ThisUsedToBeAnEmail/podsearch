#!perl -T

use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok( 'Pod::Hashed' );
}

subtest 'close html tags' => sub {
    plan tests => 13;
    test_close_html({
        element_args => {
            element_name => 'Para',
            text => 'this is a test - para',
            html_content => '<div><p>this is a test - para'
        },
        expected_html => '<div><p>this is a test - para</p>'        
    });
    test_close_html({
        element_args => {
            element_name => 'item-text',
            html_content => '<div><h5>this is a test - item'        
        },
        expected_html => '<div><h5>this is a test - item</h5>'        
    });        
    test_close_html({
        element_args => {
            element_name => 'over-text',
            html_content => '<div><h5>this is a test - over'
        },
        expected_html => '<div><h5>this is a test - over</h5>'
    });
    test_close_html({
        element_args => {
            element_name => 'Verbatim',
            html_content => '<div><pre><div>this is a test - Verbatim'        
        },
        expected_html => '<div><pre><div>this is a test - Verbatim</div></pre>'        
    }); 
    test_close_html({
        element_args => {
            element_name => 'Data',
            html_content => '<div><pre><div>this is a test - Data'
        },
        expected_html => '<div><pre><div>this is a test - Data</div></pre>'
    });
    test_close_html({
        element_args => {
            element_name => 'C',
            html_content => '<div><pre><span>foreach $item ( @many_items )'        
        },
        expected_html => '<div><pre><span>foreach $item ( @many_items )</span></pre>'        
    });   
    test_close_html({
        element_args => {
            element_name => 'L',
            html_content => '<div><a>this is a test - Link',
        },
        expected_html => '<div><a>this is a test - Link</a>'
    });
    test_close_html({
        element_args => {
            element_name => 'B',
            html_content => '<div><p><b>this is a test - bold',
        },
        expected_html => '<div><p><b>this is a test - bold</b>'        
    });
    test_close_html({
        element_args => {
            element_name => 'I',
            html_content => '<div><p><i>this is a test - itallic',
        },
        expected_html => '<div><p><i>this is a test - itallic</i>'
    });
    test_close_html({
        element_args => {
            element_name => 'E',
            html_content => '<div><p><span>this is a test - < ',
        },
        expected_html => '<div><p><span>this is a test - < </span>'        
    });
    test_close_html({
        element_args => {
            element_name => 'F',
            html_content => '<div><pre><span>this is a test - filename',
        },
        expected_html => '<div><pre><span>this is a test - filename</span></pre>'
    });
    test_close_html({
        element_args => {
            element_name => 'S',
            html_content => '<div><pre><span>this is a test - $x ? $y : $z',
        },
        expected_html => '<div><pre><span>this is a test - $x ? $y : $z</span></pre>'        
    });
    test_close_html({
        element_args => {
            element_name => 'X',
            html_content => '<div><h5>this is a test - absolutizing relative URLs',
        },
        expected_html => '<div><h5>this is a test - absolutizing relative URLs</h5>'
    });
};

subtest 'close html tags - div' => sub {
    plan tests => 13;
    test_close_html({
        element_args => {
            element_name => 'Para',
            text => 'this is a test - para',
            html_content => '<div><p>this is a test - para</p>'
        },
        no_tags => 1,
        expected_html => '<div><p>this is a test - para</p></div>'        
    });
    test_close_html({
        element_args => {
            element_name => 'item-text',
            html_content => '<div><h5>this is a test - item</h5>'        
        },
        no_tags => 1,
        expected_html => '<div><h5>this is a test - item</h5></div>'        
    });        
    test_close_html({
        element_args => {
            element_name => 'over-text',
            html_content => '<div><h5>this is a test - over</h5>'
        },
        no_tags => 1,
        expected_html => '<div><h5>this is a test - over</h5></div>'
    });
    test_close_html({
        element_args => {
            element_name => 'Verbatim',
            html_content => '<div><pre><div>this is a test - Verbatim</div></pre>'        
        },
        no_tags => 1,
        expected_html => '<div><pre><div>this is a test - Verbatim</div></pre></div>'        
    }); 
    test_close_html({
        element_args => {
            element_name => 'Data',
            html_content => '<div><pre><div>this is a test - Data</div></pre>'
        },
        no_tags => 1,
        expected_html => '<div><pre><div>this is a test - Data</div></pre></div>'
    });
    test_close_html({
        element_args => {
            element_name => 'C',
            html_content => '<div><pre><span>foreach $item ( @many_items )</span></pre>'        
        },
        no_tags => 1,
        expected_html => '<div><pre><span>foreach $item ( @many_items )</span></pre></div>'        
    });   
    test_close_html({
        element_args => {
            element_name => 'L',
            html_content => '<div><p><a>this is a test - Link</a></p>',
        },
        no_tags => 1,
        expected_html => '<div><p><a>this is a test - Link</a></p></div>'
    });
    test_close_html({
        element_args => {
            element_name => 'B',
            html_content => '<div><p><b>this is a test - bold</b></p>',
        },
        no_tags => 1, 
        expected_html => '<div><p><b>this is a test - bold</b></p></div>'        
    });
    test_close_html({
        element_args => {
            element_name => 'I',
            html_content => '<div><p><i>this is a test - itallic</i></p>',
        },
        no_tags => 1,
        expected_html => '<div><p><i>this is a test - itallic</i></p></div>'
    });
    test_close_html({
        element_args => {
            element_name => 'E',
            html_content => '<div><p><span>this is a test - < </span></p>',
        },
        no_tags => 1,
        expected_html => '<div><p><span>this is a test - < </span></p></div>'        
    });
    test_close_html({
        element_args => {
            element_name => 'F',
            html_content => '<div><pre><span>this is a test - filename</span></pre>',
        },
        no_tags => 1,
        expected_html => '<div><pre><span>this is a test - filename</span></pre></div>'
    });
    test_close_html({
        element_args => {
            element_name => 'S',
            html_content => '<div><pre><span>this is a test - $x ? $y : $z</span></pre>',
        },
        no_tags => 1,
        expected_html => '<div><pre><span>this is a test - $x ? $y : $z</span></pre></div>'        
    });
    test_close_html({
        element_args => {
            element_name => 'X',
            html_content => '<div><h5>this is a test - absolutizing relative URLs</h5>',
        },
        no_tags => 1,
        expected_html => '<div><h5>this is a test - absolutizing relative URLs</h5></div>'
    });
};

done_testing();

sub test_close_html {
    my $args = shift;
    
    my $parser = Pod::Hashed->new();
    my $element_name = $args->{element_args}{element_name};
    my $tags = $parser->content_elements->{$element_name}{tags};
    $parser->html_end_tags([{ tags => $tags, element => $element_name }]) unless $args->{no_tags};
    my $open_html = $parser->_close_html_tags($args->{element_args});
    is($open_html, $args->{expected_html}, 
        "_close_html_tags for $element_name - $args->{expected_html}");
}

1;
