package portfolio;
use Template;
use Dancer;
use CMS::Simple;
use Dancer::Plugin::Database;
use Data::Dumper;
use YAML::Syck;
use CGI;

our $CONTENT_FILE = 'content.yml';
our $VERSION = '0.1';

my $content = CMS::Simple->new(); 

sub connect_db {
    my $dbh = DBI->connect("dbi:SQLite:dbname=webdata") or
       die $DBI::errstr;

    return $dbh;
}

get '/' => sub {
    my $data = LoadFile($CONTENT_FILE);
    $content->load_content($CONTENT_FILE);
    template 'index', {'content' => reverse($data)};
};

get '/add_post' => sub {
    template 'add_post';
};

post '/add_post' => sub {
    my $add_post = $content->add_post(params->{'post_heading'}, params->{'post_text'});
    if ($add_post) {
       redirect '/';
    } else {
        'error';
    }
};

post '/save' => sub {
  my $data = LoadFile($CONTENT_FILE);
  my $id = params->{'id'};
  my $page_id = substr params->{'id'}, 6;
  my $type;

  if (length($id) >= 10) {
    $type = substr $id, 0, 7; 
    $page_id = substr params->{'id'}, 9;
  } else {
    $type = substr $id, 0, 4;
    $page_id = substr params->{'id'}, 6;
  }

  $page_id--;
  $data->{"content"}[$page_id]{"fields"}{$type} = params->{"value"};
  DumpFile($CONTENT_FILE, $data);
  return params->{'value'};
};

get '/edit_mode' => sub {
  if (session('logged_in')) {
    if (session('edit_mode') && session('edit_mode') == 1) {
      session edit_mode => 2;
      redirect '/';
    } else {
      session edit_mode => 1;
      redirect '/';
    }
  }
};

get '/__login' => sub {
    template '__login';
};

get '/logout' => sub {
  session->destroy;
  redirect '/';
};

post '/__login' => sub {
    my $db = connect_db();
    my $sql = "select * from login where username=? AND password=?";
    my $sth = $db->prepare($sql) or die $db->errstr;
    $sth->execute(params->{'username'}, params->{'password'});
    my $user = $sth->fetch;
    if (!$user) {
         template '__login';
     } else {
         session logged_in => 1;
         session username => params->{'username'};
         
         redirect '/';
     }
};

true;
