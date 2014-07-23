#!/usr/bin/env perl
# Mike Covington
# created: 2014-07-23
#
# Description:
#
use strict;
use warnings;
use autodie;
use feature 'say';

# Based on: https://www.biostars.org/p/19446/#19447

die "Usage: $0 [FASTQ-FILE] [EXPECTED-SEQ-LENGTH]\n" unless scalar @ARGV == 2;

my ( $fastq_in, $length ) = @ARGV;

open my $fastq_in_fh, "<", $fastq_in;
open my $pe1_fh, ">", "$fastq_in.pe1.fq";
open my $pe2_fh, ">", "$fastq_in.pe2.fq";
while (my $seqid = <$fastq_in_fh>) {
    my $seq = <$fastq_in_fh>;
    <$fastq_in_fh>;
    my $qual = <$fastq_in_fh>;

    chomp $seqid;
    chomp $seq;
    chomp $qual;

    my $seq_length = length $seq;

    die "Sequence length ($seq_length bp) different than expected ($length bp)\n"
        unless $seq_length == $length;

    say $pe1_fh "$seqid 0/1";
    say $pe2_fh "$seqid 0/2";

    say $pe1_fh substr $seq, 0, $seq_length / 2;
    say $pe2_fh substr $seq, $seq_length / 2, $seq_length / 2;

    say $pe1_fh "+";
    say $pe2_fh "+";

    say $pe1_fh substr $qual, 0, $seq_length / 2;
    say $pe2_fh substr $qual, $seq_length / 2, $seq_length / 2;

}
close $fastq_in_fh;
close $pe1_fh;
close $pe2_fh;

exit;
