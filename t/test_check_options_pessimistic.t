#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 8;
use Test::Deep;
use Test::Exception;
use Data::Dumper;

use Params qw[check_options];

dies_ok { check_options('?') } 'just question mark';
dies_ok { check_options('?', 'a') } 'question mark and args';
dies_ok { check_options('?', 'a', 'b') } 'question mark and too many args';
dies_ok { check_options('a?b', 'a') } 'question mark in middle of word and too many args';

dies_ok { check_options('||') } 'too many pipes';
dies_ok { check_options('|||') } 'way too many pipes';


cmp_deeply(
    {check_options('a | a', 4, {a => 5})},
    {a => 5},
    'positional and named parameter with same name, named parameter wins',
);

cmp_deeply(
    {check_options('a a a', 1, 2, 3)},
    {a => 3},
    'multiple positional parameters',
);
