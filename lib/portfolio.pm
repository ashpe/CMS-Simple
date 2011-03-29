package portfolio;
use Template;
use Dancer;
use CMS::Simple;
use Dancer::Plugin::Database;
use Data::Dumper;
use YAML::Syck;
use CGI;
use Time::Format qw(%time);

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

post '/' => sub {

    my $data = LoadFile($CONTENT_FILE);
    my $id = params->{'getid'};
    my $real_id = substr $id, 1, length($id);
    $real_id--;
  
    delete $data->{'content'}[$real_id];
    
    DumpFile($CONTENT_FILE, $data);
    redirect '/';
};

get '/add_post' => sub {
    template 'add_post';
};

post '/add_post' => sub {
    my $add_post = $content->add_post(params->{'post_heading'}, params->{'post_text'}, session('username'));
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
  $data->{"content"}[$page_id]{"fields"}{last_edited} = $time{'hhmm.yyyymmdd'};
  
  my $db = connect_db();
  
  my $sql = 'select last_modified from data_check where filename=?';
  my $sth = $db->prepare($sql) or die $db->errstr;
  $sth->execute($CONTENT_FILE);
  my $sql_last_modified = $sth->fetch;

  if ($sql_last_modified->[0] ne session('last_modified')) {
    
      session last_modified => $sql_last_modified->[0]; 
      return '<p class="error">Error: somebody else has edited this content while you were editing try again, page will refresh in 3s..</p>';
      sleep 3;
      redirect '/';

  } elsif ($sql_last_modified->[0] eq session('last_modified')) {

      my $sql = "update data_check SET last_modified=?, username=?  where filename=?";
      my $sth = $db->prepare($sql) or die $db->errstr;
      
      my $modified = $time{'hhmmss.yyyymmdd'};
      $sth->execute($modified, session('username'), $CONTENT_FILE);
      session last_modified => $modified;

      DumpFile($CONTENT_FILE, $data);
      return params->{'value'};
  }
};

get '/edit_mode' => sub {
  if (session('logged_in')) {
    if (session('edit_mode') && session('edit_mode') == 1) {
      session edit_mode => 2;
      redirect '/';
    } else {
      session edit_mode => 1;

      my $db = connect_db();
      my $sql = 'select last_modified from data_check where filename=?';
      my $sth = $db->prepare($sql) or die $db->errstr;
      $sth->execute($CONTENT_FILE);
      my $sql_last_modified = $sth->fetch;
      session last_modified => $sql_last_modified->[0];
     
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
