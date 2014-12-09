#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;
use experimental qw(switch autoderef);

my @result = ();
my $current_cell = 0;
my %stack = ();
my $level = 0;
my $comment = 0;

sub run {
  for ($_[0]) {
    when (/^Ko$/) { $result[$current_cell]++ }
    when (/^kO$/) { $result[$current_cell]-- }
    when (/^Kudah$/) { $current_cell++ }
    when (/^kudah$/) { $current_cell-- }
    when (/^Kukarek$/) { print chr $result[$current_cell] }
    default { say "\nUnexpected pkokoblem" }
  }
}

sub cycle {
  while ($result[$current_cell] > 0) {
    run $_ for @{$stack{$level}}
  }
}

while (<>) {
  while (1) {
    if (/\G[\s!?.,:;()-]+/gc) { # skip whitespace and punctuation
    } elsif (/\Gz+/gci) {
      $comment++;
    } elsif ($comment and /\G.*?(morning)?/gc) {
      $comment-- if $1;
    } elsif (/\G(Ko|kO|Kudah|kudah|Kukarek)/gc) {
      if ($level > 0) {
	push $stack{$level}, $1;
      } else {
	run $1;
      }
    } elsif (/\GKud/gc) {
      $stack{++$level} = [];
    } elsif (/\Gkud/gc) {
      cycle();
      $level--;
    } elsif (/\G(.)/gc) {
      say "\nChicktax errorek: $1";
    } else {
      last;
    }
  }
}

say '';
