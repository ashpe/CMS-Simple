#!/usr/bin/perl

use CMS::Simple;
use YAML::Syck;
use Data::Dumper;

my $hash = { 'content' => [ { id => "p1", fields => { text => "Testing", heading => "Testing 2" } }, { id => "p2" } ] };

#$data = LoadFile('content.yml');
#DumpFile('test-content.yml', $hash);


#print Dumper($data);
#print Dumper($data->{content}[0]{fields}{text});    

my $string = 'text_p3';
my $type;
my $len = length $string;
my $test; 
print length $string;
if (length($string) >= 10) {
  $type = substr $string, 0, 7;
} else {
  $type = substr $string, 0, 4;
}


print "\n";
print substr $string, 6;
print $type;
