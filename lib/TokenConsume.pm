package TokenConsume;
use strict;
use warnings;

use Exporter qw[import];
our @EXPORT_OK = qw[consume];
our $VERSION   = '0.0.1';

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
