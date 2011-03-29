#!/usr/bin/perl

open FILE, 'content.yml';

my %count;

while ( <FILE> ) {
    if ($_ !~ /(heading|posted_by|date|id|fields)/i) {
        $count{lc $_}++ for /\w+/g;
    }   
}

print "$_ => $count{$_}\n"
    for sort { $count{$b} <=> $count{$a} || $a cmp $b} keys %count;
