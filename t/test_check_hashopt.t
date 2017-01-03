#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 9;
use Test::Deep;
use Test::Exception;

use Params qw[check_hashopt];


do {
    my %hash = (key1 => 'value1', key2 => 'value2');
    cmp_deeply({check_hashopt('key1 key2', %hash)}, \%hash, 'well-formed spec');
    cmp_deeply({check_hashopt(' key1 key2', %hash)}, \%hash, 'spec with leading space');
    cmp_deeply({check_hashopt('  key1    key2   ', %hash)}, \%hash, 'spec with extra spaces');
};


do {
    my %hash = ("\n" => 1, a => 3);
    cmp_deeply({check_hashopt("\n a", %hash)}, {%hash}, 'newline is valid in keys');
};


do {
    my %hash = ("0" => 1, a => 3);
    cmp_deeply({check_hashopt("0 a", %hash)}, {%hash}, 'false key "0" is valid in keys');
};


dies_ok {check_hashopt('a', ())} 'reject hash without required argument';
dies_ok {check_hashopt('b', (a => 1, b => 2))} 'reject hash with superfluous argument';

cmp_deeply({check_hashopt('a? b', (b => 1))}, {b => 1}, 'optional argument omitted');
cmp_deeply({check_hashopt('a? b', (a => 1, b => 1))}, {a => 1, b => 1}, 'optional argument provided');
