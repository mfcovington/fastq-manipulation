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
use Cwd 'abs_path';
use File::Find;
use File::ReadBackwards;

my @directories = @ARGV;
find( \&wanted, @directories );

exit;

sub wanted {
    return unless /.+\.f(?:ast)?q$/i;
    return if -z;
    my $trunc   = is_fq_truncated($_);
    my $fq_path = abs_path($_);
    say $fq_path if $trunc;
}

sub is_fq_truncated {
    my $fq = shift;
    my $bw = File::ReadBackwards->new($fq) or die "Can't open/read $fq: $!";

    my $qual_scores = $bw->readline;
    my $qual_header = $bw->readline;
    my $sequence    = $bw->readline;
    my $seq_header  = $bw->readline;

    my $trunc = 0;

    $trunc++
        if !defined $seq_header
        || $seq_header !~ /^@/
        || $qual_header !~ /^\+/
        || length $sequence != length $qual_scores
        || $sequence !~ /[ACGTN]+/gi;

    return $trunc;
}
