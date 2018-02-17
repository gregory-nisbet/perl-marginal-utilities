package TokenConsume;
use strict;
use warnings;
use Readonly;

Readonly::Scalar our $NO_MATCH => 'NO_MATCH';
Readonly::Scalar our $MATCH => 'MATCH';
Readonly::Scalar our $MATCH_REACH_END => 'MATCH_REACH_END';

use Exporter qw[import];
our @EXPORT_OK = qw[consume is_match is_loose_match];
our $VERSION   = '0.0.1';

sub is_match {
    my ($val) = @_;
    return $val eq $MATCH;
}

sub is_loose_match {
    my ($val) = @_;
    return ($val eq $MATCH) || ($val eq $MATCH_REACH_END);
}

sub consume {
    my (undef, $pat, $pos) = @_;
    pos($_[0]) = $pos;
    my $out = undef;
    if ($_[0] =~ $pat) {
        $out = substr $_[0], $-[0], ($+[0] - $-[0]);
        pos($_[0]) = $+[0];
    }
    else {
        pos($_[0]) = $pos;
    }
    return $out;
}

1;
