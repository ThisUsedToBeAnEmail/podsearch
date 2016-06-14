#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Pod::Hashed' ) || print "Bail out!\n";
}

diag( "Testing Pod::Hashed $Pod::Hashed::VERSION, Perl $], $^X" );
