#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;
#use experimental qw(autoderef);

my @result = ();
my $current_cell = 0;
my %stack = ();
my $level = 0;
my $comment = 0;

sub run {
  if    ($_[0] =~ /^Ko$/) { $result[$current_cell]++ }
  elsif ($_[0] =~ /^kO$/) { $result[$current_cell]-- }
  elsif ($_[0] =~ /^Kudah$/) { $current_cell++ }
  elsif ($_[0] =~ /^kudah$/) { $current_cell-- }
  elsif ($_[0] =~ /^Kukarek$/) { print chr $result[$current_cell] }
}

sub cycle {
    while ($result[$current_cell] > 0) {
        run $_ for @{$stack{$level}}
    }
}

while (<>) {
    while (1) {
        if (/\G[\s!?.,:;()-]+/gc) { } # skip whitespace and punctuation
        elsif (/\Gz+/gci) { $comment++ }
        elsif ($comment and /\G.*?(morning)?/gc) { $comment-- if $1 }
        elsif (/\G(Ko|kO|Kudah|kudah|Kukarek)/gc) {
            if ($level > 0) {
                push $stack{$level}, $1;
            } else {
                run $1;
            }
        }
        elsif (/\GKud/gc) { $stack{++$level} = [] }
        elsif (/\Gkud/gc) {
            cycle();
            $level--;
        }
        elsif (/\G./gc) { }
        else { last }
    }
}

say '';
