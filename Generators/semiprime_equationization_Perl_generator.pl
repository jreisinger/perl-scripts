#!/usr/bin/perl

# Author: Daniel "Trizen" Șuteu
# License: GPLv3
# Date: 10 July 2015
# Website: https://github.com/trizen

# Generate a C program to compute the prime factors of a semiprime number.

use 5.016;
use strict;
use integer;
use warnings;

sub semiprime_equationization {
    my ($semiprime, $xlen, $ylen) = @_;

    $xlen -= 1;
    $ylen -= 1;

    my @map;
    my @result;
    my $mem = '0';

    my @x_loops;
    foreach my $i (0 .. $xlen) {
        my $start = $i == $xlen ? 1 : 0;
        if ($i == 0) {
            push @x_loops, "for (my \$x$i = 1; \$x$i < 10; \$x$i += 2) {";
        }
        else {
            unshift @x_loops, "for my \$x$i ($start .. 9) {";
        }
    }

    my @y_loops;
    foreach my $i (0 .. $ylen) {
        my $start = $i == $ylen ? 1 : 0;
        if ($i == 0) {
            push @y_loops, "for (my \$y$i = 1; \$y$i < 10; \$y$i += 2) {";
        }
        else {
            unshift @y_loops, "for my \$y$i ($start .. 9) {";
        }
    }

    push @result, @x_loops, @y_loops;

    my $counter = ($ylen + $xlen + 1);
    foreach my $result (@result) {
        $result = "LOOP$counter: " . $result;
        --$counter;
    }

    my %vars;
    foreach my $j (0 .. $ylen) {
        foreach my $i (0 .. $xlen) {
            my $expr = '(' . join(' + ', "(\$x$i * \$y$j)", grep { $_ ne '0' } $mem) . ')';

            $vars{"xy$i$j"} = $expr;
            my $n = "\$xy$i$j";

            if ($i == $xlen) {
                push @{$map[$j]}, "($n % 10)", "($n / 10)";
                $mem = '0';
            }
            else {
                push @{$map[$j]}, "($n % 10)";
                $mem = "($n / 10)";
            }
        }

        my $n = $ylen - $j;
        if ($n > 0) {
            push @{$map[$j]}, ((0) x $n);
        }

        my $m = $ylen - $n;
        if ($m > 0) {
            unshift @{$map[$j]}, ((0) x $m);
        }
    }

    my @number = reverse split //, $semiprime;

    my @mrange = (0 .. $#map);
    my $end    = $xlen + $ylen + 1;

    my %seen;
    my $initializer = sub {
        my ($str) = @_;

        while ($str =~ /\$(xy\d+)/g) {
            if (not $seen{$1}++) {
                my $init = "my \$$1 = $vars{$1};";
                __SUB__->($init);
                push @result, $init;
            }
        }
    };

    foreach my $i (0 .. $#number) {
        my $expr = '(' . join(' + ', grep { $_ ne '0' } (map { $map[$_][$i] } @mrange), $mem) . ')';
        $initializer->($expr);

        push @result, "my \$n$i = $expr;";
        my $n = "\$n$i";

        if ($i == $#number) {
            push @result,
                qq/if ($number[$i] == ($n % 10)) { printf("Cracked: /
              . ("%d" x ($xlen + 1))
              . (" * ")
              . ("%d" x ($ylen + 1))
              . qq/\\n", /
              . join(", ", (map { "\$x$_" } reverse(0 .. $xlen)), (map { "\$y$_" } reverse(0 .. $ylen)))
              . qq/); exit 0; }/;
        }
        else {
            push @result, "if ($number[$i] != ($n % 10)) { next LOOP$i; }";
            $mem = "($n / 10)";
        }
    }

    unshift @result, ('use integer;', 'use strict;', 'use warnings;');

    push @result, "}" x (1 + $xlen + 1 + $ylen);

    return @result;
}

# 71 * 43
#say for semiprime_equationization('3053', 2, 2);

# 251 * 197
#say for semiprime_equationization('49447', 3, 3);

# 7907 * 4999
say for semiprime_equationization('39527093', 4, 4);

# 37975227936943673922808872755445627854565536638199 * 40094690950920881030683735292761468389214899724061
#say for semiprime_equationization('1522605027922533360535618378132637429718068114961380688657908494580122963258952897654000350692006139', 50, 50);