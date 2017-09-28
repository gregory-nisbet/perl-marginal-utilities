package FileTokenConsume;
use strict;
use warnings;
use TokenConsume qw[consume];

# TODO allow user to specify the
# line separator in a better way than $/
# (also guard ourselves against $/ set elsewhere)
# (unless it forms part of the interface)

sub new {
    my ($cls, $fh) = @_;
    my $o = {};
    $o->{fh} = $fh;
    $o->{staging} = undef;
    bless $o, $cls;
}

sub _Is_staging_empty {
    my ($staging) = @_;
    return (not defined $staging) or pos($staging) == length($staging);
}

sub _unfold_n_lines {
    my $self = shift;
    my ($n) = shift;
    my @extracted_lines;
    for (my $i = 0; $i < $n; ++$i) {
        my $new_line = readline($self->{fh});
        last unless defined $new_line;
        push @extracted_lines, $new_line;
    }
    my $pos = pos($self->{staging});
    if (@extracted_lines) {
        $self->{line} = ($self->{line} // q[]) . join(q[], @extracted_lines);
    }
    return @extracted_lines;
}

sub consume_single_line {

}

sub _load_line {
    my $self = shift;
    if (_End_of_line($self->{line})) {
        my $line = readline($self->{fh});
    }
}
