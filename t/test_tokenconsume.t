#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 7;
use Test::Deep;
use Test::Exception;

use TokenConsume qw[consume];

do {
    my $str = "abc";
    pos($str) = 0;
    my $res = consume($str, qr/a/, 0);
    is($res, "a", "capture literal char");
};

do {
    my $str = "abc";
    pos($str) = 0;
    my $res = consume($str, qr/b/, 1);
    is($res, "b", "capture non-first literal char");
    is(pos($str), 2, "pos should advance to just after match");
};

do {
    my $str = "abc";
    pos($str) = 0;
    my $res = consume($str, qr/z/, 0);
    is($res, undef, "failed match should capture nothing");
    is(pos($str), 0, "failed match should return pos to beginning of search");
};

do {
    my $str = "abc";
    pos($str) = 0;
    my $res = consume($str, qr/z/, 1);
    is($res, undef, "non-first: failed match should capture nothing");
    is(pos($str), 1, "non-first: failed match should return pos to beginning of search");
};
