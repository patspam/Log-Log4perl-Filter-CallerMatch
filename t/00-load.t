#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Log::Log4perl::Filter::CallerMatch' );
}

diag( "Testing Log::Log4perl::Filter::CallerMatch $Log::Log4perl::Filter::CallerMatch::VERSION, Perl $], $^X" );
