#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 6;
use Test::Deep;
use Splitter qw[split_preserving_sep];

cmp_deeply([split_preserving_sep(qr/c/, 'bab')], ['bab']);
cmp_deeply([split_preserving_sep(qr/a/, 'bab')], ['b', ['a'], 'b']);

cmp_deeply([split_preserving_sep('c', 'bab')], ['bab']);
cmp_deeply([split_preserving_sep('a', 'bab')], ['b', ['a'], 'b']);

cmp_deeply([split_preserving_sep('.', 'b')], ['', ['b'], '']);

cmp_deeply([split_preserving_sep('ab?a', 'zzaazzabazz')], ['zz', ['aa'], 'zz', ['aba'], 'zz']);
