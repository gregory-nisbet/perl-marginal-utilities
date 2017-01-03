#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 7;
use Test::Deep;
use Test::Exception;

use Params qw[check_hash];


do {
    my %hash = (key1 => 'value1', key2 => 'value2');
    cmp_deeply({check_hash('key1 key2', %hash)}, \%hash, 'well-formed spec');
    cmp_deeply({check_hash(' key1 key2', %hash)}, \%hash, 'spec with leading space');
    cmp_deeply({check_hash('  key1    key2   ', %hash)}, \%hash, 'spec with extra spaces');
};


do {
    my %hash = ("\n" => 1, a => 3);
    cmp_deeply({check_hash("\n a", %hash)}, {%hash}, 'newline is valid in keys');
};


do {
    my %hash = ("0" => 1, a => 3);
    cmp_deeply({check_hash("0 a", %hash)}, {%hash}, 'false key "0" is valid in keys');
};


dies_ok {check_hash('a', ())} 'reject hash without required argument';
dies_ok {check_hash('b', (a => 1, b => 2))} 'reject hash with superfluous argument';
