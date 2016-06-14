#!perl -T

use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok( 'Pod::Hashed' );
}

subtest 'join from para' => sub {
    plan tests => 13;
    test_join_html({
        element_args => {
            element_name => 'Para',
            text => 'join some text',
            html_content => '<div><p>this is a test - para',
            embed => 1,
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test - para</p><p>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'item-text',
            text => 'join some text',
            html_content => '<div><p>this is a test - item'        
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test - item</p><h5>join some text'        
    });        
    test_join_html({
        element_args => {
            element_name => 'over-text',
            text => 'join some text',
            html_content => '<div><p>this is a test - over'
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test - over</p><h5>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'Verbatim',
            text => 'join some text',
            html_content => '<div><p>this is a test - Verbatim'        
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test - Verbatim</p><pre><div>join some text'        
    }); 
    test_join_html({
        element_args => {
            element_name => 'Data',
            text => 'join some text',
            html_content => '<div><p>this is a test - Data'
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test - Data</p><pre><div>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'C',
            text => 'foreach $item ( @many_items )',
            html_content => '<div><p>some text',        
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>some text<pre><span>foreach $item ( @many_items )'        
    });   
    test_join_html({
        element_args => {
            element_name => 'L',
            text => 'join some text',
            html_content => '<div><p>this is a test - Link',
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test - Link<a>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'B',
            text => 'join some text',
            html_content => '<div><p>this is a test - bold',
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test - bold<b>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'I',
            text => 'join some text',
            html_content => '<div><p>this is a test - itallic',
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test - itallic<i>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'E',
            text => 'lt',
            html_content => '<div><p>this is a test',
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test<span>lt'        
    });
    test_join_html({
        element_args => {
            element_name => 'F',
            text => 'filename',
            html_content => '<div><p>this is a test',
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test<pre><span>filename'
    });
    test_join_html({
        element_args => {
            element_name => 'S',
            text => '$x ? $y : $z',
            html_content => '<div><p>this is a test',
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test<pre><span>$x ? $y : $z'        
    });
    test_join_html({
        element_args => {
            element_name => 'X',
            text => 'join some text',
            html_content => '<div><p>this is a test',
        },
        orig_tag => 'Para', 
        expected_html => '<div><p>this is a test</p><h5>join some text'
    });
};

subtest 'join from item' => sub {
    plan tests => 13;
    test_join_html({
        element_args => {
            element_name => 'Para',
            text => 'join some text',
            html_content => '<div><h5>this is a test - para'
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test - para</h5><p>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'item-text',
            text => 'join some text',
            html_content => '<div><h5>this is a test - item'        
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test - item</h5><h5>join some text'        
    });        
    test_join_html({
        element_args => {
            element_name => 'over-text',
            text => 'join some text',
            html_content => '<div><h5>this is a test - over'
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test - over</h5><h5>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'Verbatim',
            text => 'join some text',
            html_content => '<div><h5>this is a test - Verbatim'        
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test - Verbatim</h5><pre><div>join some text'        
    }); 
    test_join_html({
        element_args => {
            element_name => 'Data',
            text => 'join some text',
            html_content => '<div><h5>this is a test - Data'
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test - Data</h5><pre><div>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'C',
            text => 'foreach $item ( @many_items )',
            html_content => '<div><h5>some text',        
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>some text<pre><span>foreach $item ( @many_items )'        
    });   
    test_join_html({
        element_args => {
            element_name => 'L',
            text => 'join some text',
            html_content => '<div><h5>this is a test - Link',
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test - Link<a>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'B',
            text => 'join some text',
            html_content => '<div><h5>this is a test - bold',
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test - bold<b>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'I',
            text => 'join some text',
            html_content => '<div><h5>this is a test - itallic',
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test - itallic<i>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'E',
            text => 'lt',
            html_content => '<div><h5>this is a test',
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test<span>lt'        
    });
    test_join_html({
        element_args => {
            element_name => 'F',
            text => 'filename',
            html_content => '<div><h5>this is a test',
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test<pre><span>filename'
    });
    test_join_html({
        element_args => {
            element_name => 'S',
            text => '$x ? $y : $z',
            html_content => '<div><h5>this is a test',
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test<pre><span>$x ? $y : $z'        
    });
    test_join_html({
        element_args => {
            element_name => 'X',
            text => 'join some text',
            html_content => '<div><h5>this is a test',
        },
        orig_tag => 'item-text', 
        expected_html => '<div><h5>this is a test</h5><h5>join some text'
    });
};

subtest 'join from over' => sub {
    plan tests => 13;
    test_join_html({
        element_args => {
            element_name => 'Para',
            text => 'join some text',
            html_content => '<div><h5>this is a test - para'
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test - para</h5><p>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'item-text',
            text => 'join some text',
            html_content => '<div><h5>this is a test - item'        
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test - item</h5><h5>join some text'        
    });        
    test_join_html({
        element_args => {
            element_name => 'over-text',
            text => 'join some text',
            html_content => '<div><h5>this is a test - over'
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test - over</h5><h5>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'Verbatim',
            text => 'join some text',
            html_content => '<div><h5>this is a test - Verbatim'        
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test - Verbatim</h5><pre><div>join some text'        
    }); 
    test_join_html({
        element_args => {
            element_name => 'Data',
            text => 'join some text',
            html_content => '<div><h5>this is a test - Data'
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test - Data</h5><pre><div>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'C',
            text => 'foreach $item ( @many_items )',
            html_content => '<div><h5>some text',        
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>some text<pre><span>foreach $item ( @many_items )'        
    });   
    test_join_html({
        element_args => {
            element_name => 'L',
            text => 'join some text',
            html_content => '<div><h5>this is a test - Link',
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test - Link<a>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'B',
            text => 'join some text',
            html_content => '<div><h5>this is a test - bold',
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test - bold<b>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'I',
            text => 'join some text',
            html_content => '<div><h5>this is a test - itallic',
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test - itallic<i>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'E',
            text => 'lt',
            html_content => '<div><h5>this is a test',
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test<span>lt'        
    });
    test_join_html({
        element_args => {
            element_name => 'F',
            text => 'filename',
            html_content => '<div><h5>this is a test',
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test<pre><span>filename'
    });
    test_join_html({
        element_args => {
            element_name => 'S',
            text => '$x ? $y : $z',
            html_content => '<div><h5>this is a test',
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test<pre><span>$x ? $y : $z'        
    });
    test_join_html({
        element_args => {
            element_name => 'X',
            text => 'join some text',
            html_content => '<div><h5>this is a test',
        },
        orig_tag => 'over-text', 
        expected_html => '<div><h5>this is a test</h5><h5>join some text'
    });
};

subtest 'join from verbatim' => sub {
    plan tests => 13;
    test_join_html({
        element_args => {
            element_name => 'Para',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - para'
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test - para</div></pre><p>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'item-text',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - item'        
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test - item</div></pre><h5>join some text'        
    });        
    test_join_html({
        element_args => {
            element_name => 'over-text',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - over'
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test - over</div></pre><h5>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'Verbatim',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - Verbatim'        
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test - Verbatim</div></pre><pre><div>join some text'        
    }); 
    test_join_html({
        element_args => {
            element_name => 'Data',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - Data'
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test - Data</div></pre><pre><div>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'C',
            text => 'foreach $item ( @many_items )',
            html_content => '<div><pre><div>some text',        
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>some text<pre><span>foreach $item ( @many_items )'
    });   
    test_join_html({
        element_args => {
            element_name => 'L',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - Link',
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test - Link<a>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'B',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - bold',
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test - bold<b>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'I',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - itallic',
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test - itallic<i>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'E',
            text => 'lt',
            html_content => '<div><pre><div>this is a test',
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test<span>lt'        
    });
    test_join_html({
        element_args => {
            element_name => 'F',
            text => 'filename',
            html_content => '<div><pre><div>this is a test',
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test<pre><span>filename'
    });
    test_join_html({
        element_args => {
            element_name => 'S',
            text => '$x ? $y : $z',
            html_content => '<div><pre><div>this is a test',
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test<pre><span>$x ? $y : $z' 
    });
    test_join_html({
        element_args => {
            element_name => 'X',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test',
        },
        orig_tag => 'Verbatim', 
        expected_html => '<div><pre><div>this is a test</div></pre><h5>join some text'
    });
};

subtest 'join from data' => sub {
    plan tests => 13;
    test_join_html({
        element_args => {
            element_name => 'Para',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - para'
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test - para</div></pre><p>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'item-text',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - item'        
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test - item</div></pre><h5>join some text'        
    });        
    test_join_html({
        element_args => {
            element_name => 'over-text',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - over'
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test - over</div></pre><h5>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'Verbatim',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - Verbatim'        
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test - Verbatim</div></pre><pre><div>join some text'        
    }); 
    test_join_html({
        element_args => {
            element_name => 'Data',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - Data'
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test - Data</div></pre><pre><div>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'C',
            text => 'foreach $item ( @many_items )',
            html_content => '<div><pre><div>some text',        
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>some text<pre><span>foreach $item ( @many_items )'
    });   
    test_join_html({
        element_args => {
            element_name => 'L',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - Link',
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test - Link<a>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'B',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - bold',
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test - bold<b>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'I',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test - itallic',
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test - itallic<i>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'E',
            text => 'lt',
            html_content => '<div><pre><div>this is a test',
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test<span>lt'        
    });
    test_join_html({
        element_args => {
            element_name => 'F',
            text => 'filename',
            html_content => '<div><pre><div>this is a test',
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test<pre><span>filename'
    });
    test_join_html({
        element_args => {
            element_name => 'S',
            text => '$x ? $y : $z',
            html_content => '<div><pre><div>this is a test',
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test<pre><span>$x ? $y : $z' 
    });
    test_join_html({
        element_args => {
            element_name => 'X',
            text => 'join some text',
            html_content => '<div><pre><div>this is a test',
        },
        orig_tag => 'Data', 
        expected_html => '<div><pre><div>this is a test</div></pre><h5>join some text'
    });
};

subtest 'join from C' => sub {
    plan tests => 13;
    test_join_html({
        element_args => {
            element_name => 'Para',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test - para'
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test - para</span></pre><p>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'item-text',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test - item'        
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test - item</span></pre><h5>join some text'        
    });        
    test_join_html({
        element_args => {
            element_name => 'over-text',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test - over'
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test - over</span></pre><h5>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'Verbatim',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test - Verbatim'        
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test - Verbatim</span></pre><pre><div>join some text'        
    }); 
    test_join_html({
        element_args => {
            element_name => 'Data',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test - Data'
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test - Data</span></pre><pre><div>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'C',
            text => 'foreach $item ( @many_items )',
            html_content => '<div><pre><span>some text',        
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>some text foreach $item ( @many_items )'
    });   
    test_join_html({
        element_args => {
            element_name => 'L',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test - Link',
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test - Link</span></pre><a>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'B',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test - bold',
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test - bold</span></pre><b>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'I',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test - itallic',
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test - itallic</span></pre><i>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'E',
            text => 'lt',
            html_content => '<div><pre><span>this is a test',
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test</span></pre><span>lt'        
    });
    test_join_html({
        element_args => {
            element_name => 'F',
            text => 'filename',
            html_content => '<div><pre><span>this is a test',
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test</span></pre><pre><span>filename'
    });
    test_join_html({
        element_args => {
            element_name => 'S',
            text => '$x ? $y : $z',
            html_content => '<div><pre><span>this is a test',
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test</span></pre><pre><span>$x ? $y : $z' 
    });
    test_join_html({
        element_args => {
            element_name => 'X',
            text => 'join some text',
            html_content => '<div><pre><span>this is a test',
        },
        orig_tag => 'C', 
        expected_html => '<div><pre><span>this is a test</span></pre><h5>join some text'
    });
};

subtest 'join from L' => sub {
    plan tests => 13;
    test_join_html({
        element_args => {
            element_name => 'Para',
            text => 'join some text',
            html_content => '<div><a>this is a test - para'
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test - para</a><p>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'item-text',
            text => 'join some text',
            html_content => '<div><a>this is a test - item'        
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test - item</a><h5>join some text'        
    });        
    test_join_html({
        element_args => {
            element_name => 'over-text',
            text => 'join some text',
            html_content => '<div><a>this is a test - over'
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test - over</a><h5>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'Verbatim',
            text => 'join some text',
            html_content => '<div><a>this is a test - Verbatim'        
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test - Verbatim</a><pre><div>join some text'        
    }); 
    test_join_html({
        element_args => {
            element_name => 'Data',
            text => 'join some text',
            html_content => '<div><a>this is a test - Data'
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test - Data</a><pre><div>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'C',
            text => 'foreach $item ( @many_items )',
            html_content => '<div><a>some text',        
        },
        orig_tag => 'L', 
        expected_html => '<div><a>some text</a><pre><span>foreach $item ( @many_items )'
    });   
    test_join_html({
        element_args => {
            element_name => 'L',
            text => 'join some text',
            html_content => '<div><a>this is a test - Link',
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test - Link join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'B',
            text => 'join some text',
            html_content => '<div><a>this is a test - bold',
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test - bold</a><b>join some text'        
    });
    test_join_html({
        element_args => {
            element_name => 'I',
            text => 'join some text',
            html_content => '<div><a>this is a test - itallic',
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test - itallic</a><i>join some text'
    });
    test_join_html({
        element_args => {
            element_name => 'E',
            text => 'lt',
            html_content => '<div><a>this is a test',
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test</a><span>lt'        
    });
    test_join_html({
        element_args => {
            element_name => 'F',
            text => 'filename',
            html_content => '<div><a>this is a test',
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test</a><pre><span>filename'
    });
    test_join_html({
        element_args => {
            element_name => 'S',
            text => '$x ? $y : $z',
            html_content => '<div><a>this is a test',
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test</a><pre><span>$x ? $y : $z' 
    });
    test_join_html({
        element_args => {
            element_name => 'X',
            text => 'join some text',
            html_content => '<div><a>this is a test',
        },
        orig_tag => 'L', 
        expected_html => '<div><a>this is a test</a><h5>join some text'
    });
};


done_testing();

sub test_join_html {
    my $args = shift;
 
    my $parser = Pod::Hashed->new();
    my $element_name = $args->{element_args}{element_name};
    my $orig = $args->{orig_tag};
    my $orig_el = $parser->content_elements->{$orig};
    $parser->html_end_tags([{ tags => $orig_el->{tags}, element => $orig }]);
        
    my $join_el = $parser->content_elements->{$element_name};
    $args->{element_args}{tags} = $join_el->{tags};
    $args->{element_args}{embed} = $join_el->{embed} ? 1 : undef;
    
    my $join_html = $parser->_join_html_tags($args->{element_args});
    is($join_html, $args->{expected_html}, 
        "_join_html_tags for $element_name - $args->{expected_html}");
}

1;
