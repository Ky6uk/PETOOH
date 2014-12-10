#!/usr/bin/env perl

use strict;
use warnings;

do { print "\n    USAGE: $0 /path/to/file.koko\n" } unless $ARGV[0];

open my $fh, "<", $ARGV[0] or die $!;

my ($char, @result);
my $instruction = '';
my $current_cell = 0;
my $stack = {};
my $level = 0;

while ( read($fh, $char, 1) != 0 ) {
    next if $char !~ m/[adehkKoOru]/;

    my $temp = $instruction . $char;

    if ($temp eq "Ko")    {
        ($level > 0) ?
            push $stack->{$level}, $temp :
            $result[$current_cell]++;

        $instruction = '';
    }
    elsif ($temp eq "kO")    {
        ($level > 0) ?
            push $stack->{$level}, $temp :
            $result[$current_cell]--;

        $instruction = '';
    }
    elsif ($temp eq "Kudah") {
        ($level > 0) ?
            push $stack->{$level}, $temp :
            $current_cell++;

        $instruction = '';
    }
    elsif ($temp eq "kudah") {
        ($level > 0) ?
            push $stack->{$level}, $temp :
            $current_cell--;

        $instruction = '';
    }
    elsif ($instruction eq "Kud" and $char ne "a") {
        $stack->{++$level} = [];
        $instruction = $char;
    }
    elsif ($instruction eq "kud" and $char ne "a") {
        &cycle();
        $level--;
        $instruction = $char;
    }
    elsif ($temp eq "Kukarek") {
        ($level > 0) ?
            push $stack->{$level}, $temp :
            print chr $result[$current_cell];

        $instruction = '';
    }
    else { $instruction .= $char }
}

close $fh;

sub cycle {
    while ( $result[$current_cell] > 0 ) {
        foreach my $item ( @{$stack->{$level}} ) {
            if ($item eq "Ko") { $result[$current_cell]++ }
            elsif ($item eq "kO") { $result[$current_cell]-- }
            elsif ($item eq "Kudah") { $current_cell++ }
            elsif ($item eq "kudah") { $current_cell-- }
            elsif ($item eq "Kukarek") { print chr $result[$current_cell] }
        }
    }
}

print "\n";