#!/usr/bin/perl

# Author: Daniel "Trizen" Șuteu
# License: GPLv3
# Date: 15 October 2016
# Website: https://github.com/trizen

# A provable primality test, based on Fermat's little theorem.

# Pseudoprimes are eliminated in the following way:
#
#    Let "n" be a Fermat pseudoprime to base 2. (OEIS: A001567)
#    Let "k" be the number of primes bellow the square root of "n".
#
#    The smallest prime factor of such "n", is always <= nth_prime(k), because nth_prime(k)**2 <= n.
#
# Therefore, we can check "n" for divisibility with the first "k" primes, where each prime is <= sqrt(n).

# See also:
#   https://oeis.org/A001567
#   https://oeis.org/A177415
#   https://en.wikipedia.org/wiki/Fermat%27s_little_theorem

use 5.010;
use strict;
use integer;
use warnings;

use ntheory qw(powmod sqrtint next_prime);

sub is_provable_prime {
    my ($n) = @_;

    return 1 if $n == 2;
    return 0 if powmod(2, $n - 1, $n) != 1;

    my $limit = sqrtint($n);

    for (my $p = 2 ; $p <= $limit ; $p = next_prime($p)) {
        ($n % $p) == 0 and return 0;
    }

    return 1;
}

#
## Tests
#

say is_provable_prime(267_391);       # prime
say is_provable_prime(23_498_729);    # composite
say is_provable_prime(206_601);       # composite

my @pseudoprimes = (
                    341,          561,          645,          1105,         1387,         1729,
                    1905,         2047,         2465,         2701,         2821,         3277,
                    4033,         4369,         4371,         4681,         5461,         6601,
                    7957,         8321,         8481,         8911,         10261,        10585,
                    12801,        13741,        13747,        13981,        14491,        15709,
                    15841,        16705,        18721,        19951,        23377,        25761,
                    29341,        31621,        42799,        49141,        60787,        65077,
                    80581,        83333,        85489,        104653,       123251,       150851,
                    164737,       188057,       206601,       219781,       226801,       233017,
                    241001,       249841,       556169,       580337,       647089,       665281,
                    721801,       873181,       1073021,      1109461,      1194649,      1397419,
                    1529185,      2134277,      2162721,      2163001,      2491637,      2977217,
                    3235699,      4259905,      4469471,      5351537,      5423713,      6118141,
                    6122551,      6952037,      6973063,      7306261,      8388607,      8745277,
                    9480461,      12327121,     15976747,     16973393,     18073817,     21414169,
                    23261713,     25457833,     26840269,     27108397,     27118601,     30418957,
                    35851037,     38118763,     38439523,     40165093,     42485119,     49075417,
                    64605041,     80142761,     82506439,     88930463,     93926197,     96888641,
                    100860997,    127710563,    128027831,    131421541,    158397247,    177951973,
                    178956971,    214858717,    224957893,    260963389,    282769771,    283936001,
                    287449091,    311177213,    326266051,    328302901,    346080391,    374296627,
                    392534231,    442181291,    470896201,    496560349,    502686713,    504454879,
                    536357053,    605454917,    615344227,    706728377,    733995883,    775006201,
                    859996477,    934168861,    998724481,    1046080339,   1150534747,   1229751667,
                    1297443913,   1409372779,   1441678411,   1452201241,   1502171117,   1568471813,
                    1568916311,   1569843451,   1571111587,   1572279791,   1574362441,   1574601601,
                    1576187713,   1577983489,   1578009401,   1580201501,   1581576641,   1581714481,
                    1581943837,   1582212101,   1582783777,   1582886341,   1583230241,   1583658649,
                    1584462331,   1586436193,   1587650401,   1595647351,   1617921667,   1647290503,
                    1689957383,   1766984389,   1957705177,   2394311233,   2593490153,   2680980823,
                    2682823681,   2700891839,   2848722131,   2967689941,   3037203431,   3179632801,
                    3680455117,   3847985837,   4048493983,   4485854029,   4505944951,   4687014697,
                    4756261033,   5293826641,   5594740297,   5718125093,   5721339937,   6151683847,
                    6173554801,   6982222627,   7384931581,   7522506317,   7619387441,   8566474897,
                    8943255721,   9269624041,   9270156781,   10307702777,  10508865557,  10556818561,
                    11017298857,  11101740563,  11113411051,  11150425651,  12155205221,  13621136761,
                    13654442299,  13929726149,  13996356433,  14133425021,  16366308653,  18792298829,
                    19079700641,  19592685811,  19837117081,  21201657781,  21830402981,  22936695931,
                    23257424851,  24761034097,  27487685837,  27569184173,  28600450013,  28914400891,
                    32191533037,  34533696773,  36402353921,  36898628521,  38743549573,  38899910171,
                    41888166841,  43041428761,  43724098601,  44337786643,  45098277641,  48902638541,
                    50273289541,  55540917631,  55581764761,  60457358263,  63825913441,  66039446611,
                    67834923733,  69387470851,  70443105013,  71141508391,  73300476961,  76113219673,
                    80368741441,  82808343307,  84597588241,  85211142433,  87677597989,  87831963521,
                    91452735151,  91831408373,  93535327117,  96387738301,  107670334133, 113144104361,
                    115312622617, 116797240561, 122269758397, 126391801777, 131954846971, 133264990223,
                    133859814121, 136030679969, 147352368601, 148238565707, 153275722181, 168273605561,
                    168606165797, 169309499101, 180718941077, 191215103311, 191562996773, 195305452021,
                    196244895493, 196859444237, 204636421771, 205655675861, 214958816857, 219954435301,
                    223690461479, 236116537141, 243572554427, 244074292591, 253845561341, 260907275113,
                    275889319273, 277795574519, 296639937361, 320618589589, 327000122833, 327815532721,
                    352201874909, 372771890461, 380639219761, 384580956313, 403233535877, 440992209401,
                    444245107477, 447782944841, 476857881917, 488720358461, 499454546561, 519555638461,
                    526241344933, 564596130317, 579475017073, 580664132621, 607582708823, 615562276187,
                    637374441233, 664983802339, 702703677001, 733007751851, 743449858187, 759646768061,
                    767947060051, 805722570337, 844432857757, 854533883617, 918929668751, 937898724127,
                    951593759191, 951957248381, 969818939597, 998986073837, 998997586201, 999034637833,
                    999060235097, 999219600889, 999236382301, 999253360153, 999308638021, 999406030321,
                    999407657821, 999431614501, 999459365053, 999504724681, 999585999413, 999647922737,
                    999746703869, 999828475651, 999855751441, 999857310721,
                   );

foreach my $pp (@pseudoprimes) {
    is_provable_prime($pp) && warn "error for pseudoprime: $pp";
}

my $count = 0;
my $limit = 10000;
foreach my $i (0 .. $limit) {
    ++$count if is_provable_prime($i);
}

say "There are $count primes bellow $limit.";
