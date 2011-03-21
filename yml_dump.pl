#!/usr/bin/perl

use YAML::Syck;
use Data::Dumper;

$data = LoadFile('content.yml');
DumpFile('content.yml', $data);
        
print Dumper($data);
    
