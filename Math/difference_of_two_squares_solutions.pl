#!/usr/bin/perl

# Daniel "Trizen" Șuteu
# Date: 09 August 2017
# Edit: 12 August 2017
# https://github.com/trizen

# An efficient algorithm for finding solutions to the equation:
#
#   x^2 - y^2 = n
#
# where `n` is known (along with its prime factorization).

# The algorithm uses the divisors of `n` to generate all the non-negative integer solutions.

use 5.010;
use strict;
use warnings;

use ntheory qw(divisors);

sub difference_of_two_squares_solutions {
    my ($n) = @_;

    my @solutions;
    foreach my $divisor (divisors($n)) {

        last if $divisor > sqrt($n);

        my $p = $divisor;
        my $q = $n / $divisor;

        ($p + $q) % 2 == 0 or next;

        my $x = ($q + $p) >> 1;
        my $y = ($q - $p) >> 1;

        unshift @solutions, [$x, $y];
    }

    return @solutions;
}

my $n         = 12345;
my @solutions = difference_of_two_squares_solutions($n);

foreach my $solution (@solutions) {
    say "$solution->[0]^2 - $solution->[1]^2 = $n";
}

__END__
419^2 - 404^2 = 12345
1237^2 - 1232^2 = 12345
2059^2 - 2056^2 = 12345
6173^2 - 6172^2 = 12345
