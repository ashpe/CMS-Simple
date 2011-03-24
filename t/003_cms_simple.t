#!/usr/bin/perl

use Modern::Perl;
use Test::More;
use CMS::Simple;
use Data::Dumper;

my $content = CMS::Simple->new();

note "Loading data from content.yml"; {
   
    is $content->load_content('content.yml'), 'content.yml',
    "Content loaded."; 
    
    my $get_content = $content->get_content();    

}

note "Adding posts"; {
    
    my $new_post = $content->add_post('New post', 'This is content');
    ok $new_post;

    my $newest_post = $content->add_post('ID Test', 'Does the ID incremenet each time properly?');
    ok $newest_post;

}

done_testing();
