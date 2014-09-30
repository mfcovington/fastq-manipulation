#!/usr/bin/env perl
# Mike Covington
# created: 2014-09-29
#
# Description:
#
use strict;
use warnings;
use autodie;
use feature 'say';
use File::ReadBackwards;

my $fq = $ARGV[0];
my $bw = File::ReadBackwards->new($fq) or die "Can't open/read $fq: $!";

my $qual_scores = $bw->readline;
my $qual_header = $bw->readline;
my $sequence    = $bw->readline;
my $seq_header  = $bw->readline;

my $trunc = 0;

if ( defined $seq_header ) {

    $trunc++
        if $seq_header !~ /^@/
        || $qual_header !~ /^\+/
        || length $sequence != length $qual_scores
        || $sequence !~ /[ACGTN]+/gi;
}
else { $trunc++ }

print <<EOF;
Final Read:
seq_header   -  $seq_header
sequence     -  $sequence
qual_header  -  $qual_header
qual_scores  -  $qual_scores
TRUNCATED?   -  $trunc
EOF
