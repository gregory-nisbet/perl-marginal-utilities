#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 9;
use Test::Deep;
use Test::Exception;

use Params qw[check_options];

# happy path tests
cmp_deeply({check_options('')}, {}, 'no arguments');
cmp_deeply({check_options('|')}, {}, 'no arguments just pipe');
cmp_deeply({check_options('a', 1)}, {a => 1}, 'single positional parameter');
cmp_deeply({check_options('|a', {a => 2})}, {a => 2}, 'single named parameter');
cmp_deeply({check_options('| a', {a => 2})}, {a => 2}, 'single named parameter with space');

cmp_deeply(
    {check_options('b | a', 3, {a => 2})},
    {a => 2, b => 3},
    'one positional and one named parameter',
);

cmp_deeply(
    {check_options('a b | c', 3, 4, {c => 5})},
    {a => 3, b => 4, c => 5},
    'two positional and one named parameter',
);

cmp_deeply(
    {check_options('|c?', {})},
    {},
    'default parameter not provided',
);

cmp_deeply(
    {check_options('|c?', {c => 5})},
    {c => 5},
    'default parameter provided',
);
