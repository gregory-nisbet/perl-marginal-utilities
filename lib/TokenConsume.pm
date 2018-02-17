package TokenConsume;
use strict;
use warnings;
use Readonly;

Readonly::Scalar our $NO_MATCH => 'NO_MATCH';
Readonly::Scalar our $MATCH => 'MATCH';
Readonly::Scalar our $MATCH_REACH_END => 'MATCH_REACH_END';

use Exporter qw[import];
our @EXPORT_OK = qw[consume];
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

# return
# (did you reach the end, last offset)
#
# NO_MATCH
# MATCH
# MATCH_REACH_END
sub consume_offsets {
    my (undef, $pat, $pos) = @_;
    pos($_[0]) = $pos;
    my $upper_bound = undef;
    if ($_[0] =~ $pat) {
        $upper_bound = $+[0];
        pos($_[0]) = $upper_bound;
    }
    else {
        pos($_[0]) = $pos;
    }
    my $len = length $_[0];

    my @res;
    if (defined $out) {
        if ($len == $out) { @res = (MATCH_REACH_END, $pos, $upper_bound); }
        else { @res = (MATCH, $pos, $upper_bound); }
    } else {
        @res = (NO_MATCH, undef, undef);
    }

    if (wantarray) { return @res; }
    elsif (defined wantarray) {
        warn 'consume_offset called in scalar context';
        return $res[0];
    }
    else {
        warn 'context called in void context';
        return;
    }
}

1;
