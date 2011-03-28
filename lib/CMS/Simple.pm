package CMS::Simple;

use Modern::Perl;
use Moose;
use autodie;
use YAML::Syck;
use Carp qw( croak );
use Time::Format qw(%time %strftime %manip);
use Data::Dumper;

has 'filename', is => 'rw', isa => 'Str';

# Load file with all content and store it.
sub load_content {
    my ($self, $file_name) = @_;
    $self->filename($file_name); 
    return $self->filename;
}

# Return all content from loaded file.
sub get_content {
    my ($self) = @_;
    if ($self->filename) {
        my $all_content = LoadFile($self->filename);
        return $all_content;
    } else {
        return {};
    }
}

# Add new post to main content
sub add_post {
    my ($self, $heading, $text, $posted_by) = @_;
    my $all_content = $self->get_content();
    my $total_posts = scalar @{$all_content->{content}};
    my $next_id = "p" . ($total_posts+1);

    if ($heading !~ /<[^<>]+>/) {
        $heading = "<h1> " . $heading . " </h1>";
    } 

    if ($text !~ /<[^<>]+>/) {
        $text = "<p> " . $text . " </p>";
    }

    $all_content->{content}[$total_posts]{id} = $next_id;
    $all_content->{content}[$total_posts]{fields}{heading} = $heading;
    $all_content->{content}[$total_posts]{fields}{text} = $text;
    $all_content->{content}[$total_posts]{fields}{posted_by} = $posted_by;
    $all_content->{content}[$total_posts]{fields}{date} = $time{'hhmm.yyyymmdd'};

    DumpFile($self->filename, $all_content);
    
    return 1;
}


1;
