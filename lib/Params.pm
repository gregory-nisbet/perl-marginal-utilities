package Params;
use strict;
use warnings;
use Exporter qw[import];
our @EXPORT_OK = qw[
    check_hash
    check_hashopt
    check_options
];


# checks if a hash contains only the keys given
# keys are specified in a space-delimited string
# there is no quoting mechanism and no way to write an empty
# string literal
# duplicate keys are ignored.
sub check_hash {
    my ($specifier, %args) = @_;

    my @expected_keys = ($specifier =~ m/[^ ]+/g);
    my %key_counter = map {$_ => 1} @expected_keys;

    while (my ($key, $value) = each %args) {
        exists $key_counter{$key} or die (sprintf "expected is missing. key: '%s'", $key);
        delete $key_counter{$key};
    }

    if (%key_counter) {
        die "unexpected key!";
    }
    return %args;
}


# supports a simple grammar
# words are delimited by spaces
sub check_hashopt {
    my ($specifier, %args) = @_;

    my @expected_keys = ($specifier =~ m/[^ ]+/g);
    my %mandatory_key_counter;
    my %optional_key;
    for my $key (@expected_keys) {
        if ($key =~ /[?]\z/) {
            chop $key;
            $key =~ /[?]/ and die "key cannot contain '?'";
            $optional_key{$key} = 1;
        } else {
            $key =~ /[?]/ and die "key cannot contain '?'";
            $mandatory_key_counter{$key} = 1;
        }
    }

    while (my ($key, $value) = each %args) {
        (exists $mandatory_key_counter{$key} or exists $optional_key{$key}) or
            die (sprintf "expected is missing. key: '%s'", $key);
        delete $mandatory_key_counter{$key};
    }

    if (%mandatory_key_counter) {
        die "unexpected key!: " . join ',', (keys %mandatory_key_counter);
    }
    return %args;
}


# supports a more complicated grammar
# uses a specifier string like 'a b c | d e f?'
# a, b, and c are required positional parameters
# d and e are parameters in the options hashref
# f is an optional parameter in the options hashref
# a paramater ending in ? is considered optional
#
# doesn't actually check for invalid ? stuff
#
# how do we deal with duplicate keys?
#
# Is it possible to have errors specific to
# whether a positional or keyword parameter is missing
#
# or would that require inspecting the type of the last argument?
sub check_options {
    my ($specifier, @args) = @_;

    my %out;
    my $positional_chunk;
    my $named_chunk;
    my @positional_words;
    my @named_words;
    my $expected_args_length;
    my %key_counter;
    my %mandatory_named_arg;
    my %optional_named_arg;
    my $options_ref;

    # split the specifier string up into two bits
    ($positional_chunk, $named_chunk) = split /[|]/, $specifier, 2;
    $positional_chunk //= '';
    $named_chunk //= '';

    # split the positional portion of the specifier string into words
    if ($positional_chunk ne '') {
        @positional_words = split /[ ]*/, $positional_chunk;
        @positional_words = grep { $_ ne '' } @positional_words;
    }

    # validate the positional words
    /[ |?]/ and die 'invalid specifier' foreach @positional_words;

    # split the nonpositional portion of the specifier string into words
    if ($named_chunk ne '') {
        @named_words = split /[ ]*/, $named_chunk;
        @named_words = grep {$_ ne '' and $_ ne '?'} @named_words;
    }

    # validate the named words
    /[ |?]/ and die 'invalid specifier' foreach @named_words;

    $expected_args_length = @positional_words;
    if (@named_words) {
        $expected_args_length++;
    }

    $expected_args_length == @args or die 'wrong number of arguments';

    # populate the out parameter with positional arguments
    for (my $i = 0; $i < @positional_words; $i++) {
        $out{$positional_words[$i]} = $args[$i];
    }

    # construct hash tables to store the optional and non-optional
    # keys
    for my $word (@named_words) {
        if ($word =~  /\A(.*)[?]\z/s) {
            $optional_named_arg{$1} = 1;
        } else {
            $mandatory_named_arg{$word} = 1;
        }
    }

    # set the options ref if we have named arguments
    if (@named_words) {
        $options_ref = $args[$#args];
        %key_counter = %mandatory_named_arg;
        while (my ($key, $value) = each %$options_ref) {
            if (exists $mandatory_named_arg{$key}) {
                delete $key_counter{$key};
                $out{$key} = $value;
            } elsif (exists $optional_named_arg{$key}) {
                $out{$key} = $value;
            } else {
                die (sprintf "invalid key in options '%s'", $key);
            }
        }
    }
    %out;
}


1;
