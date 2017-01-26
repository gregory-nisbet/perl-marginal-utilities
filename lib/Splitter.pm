package Splitter;
use strict;
use warnings;

use Exporter qw[import];
our @EXPORT_OK = qw[split_preserving_sep];

sub split_preserving_sep {
    my ($pat, $str) = @_;

    my $original_pos = pos $str;
    pos($str) = 0;
    
    my $start = 0;
    my $m_start = 0;
    my $m_stop = 0;

    my @out;

    while ($str =~ m/$pat/g) {
        my $m_start = $-[0];
        my $m_stop = $+[0];

        push @out, (substr $str, $start, ($m_start - $start));
        push @out, [substr $str, $m_start, ($m_stop - $m_start)];

        $start = $m_stop;
    }

    push @out, (substr $str, $start, (length($str) - $start));
    pos($str) = $original_pos;

    @out;
}

1;
