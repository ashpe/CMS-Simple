package portfolio;
use Template;
use Dancer;
use CMS::Simple;
use Dancer::Plugin::Database;
use Data::Dumper;
use YAML::Syck;
use CGI;
use Time::Format qw(%time);
use File::Flock;
use Try::Tiny;
use autodie;

our $DATABASE_FILE = 'webdata';
our $CONTENT_FILE = 'content.yml';
our $VERSION = '0.1';

my $content = CMS::Simple->new(); 

sub connect_db {
    my $dbh = DBI->connect("dbi:SQLite:dbname=webdata", {AutoCommit => 0});
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
  
  try {
    lock($CONTENT_FILE);
   

    my $db = connect_db(); 
    $db->begin_work();
    my $sql = 'select last_modified from data_check where filename=?';
    my $sth = $db->prepare($sql);
    $sth->execute($CONTENT_FILE);
    my $sql_last_modified = $sth->fetch;
    $db->commit();

    if ($sql_last_modified->[0] ne session('last_modified')) {
        
        session last_modified => $sql_last_modified->[0]; 
        return "<p class='error'>Error: somebody else has edited this content while you were editing try again, click <a href='./'>here</a> to try again..</p>";

      } elsif ($sql_last_modified->[0] eq session('last_modified')) {
        
        $db->begin_work();  
        my $sql = "update data_check SET last_modified=?, username=?  where filename=?";
        my $sth = $db->prepare($sql);
          
        my $modified = $time{'hhmmss.yyyymmdd'};
        $sth->execute($modified, session('username'), $CONTENT_FILE);
        session last_modified => $modified;
    
        DumpFile($CONTENT_FILE, $data);
        $db->commit();
        return params->{'value'};
    } catch {
        warn $_;
    }
  } finally {
      unlock($CONTENT_FILE);
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
      $db->begin_work();
      my $sql = 'select last_modified from data_check where filename=?';
      my $sth = $db->prepare($sql);
      $sth->execute($CONTENT_FILE);
      my $sql_last_modified = $sth->fetch;
      $db->commit();

      session last_modified => $sql_last_modified->[0];
         
      redirect '/';
    }
  }
};
post '/view_comments' => sub {
   my $data = LoadFile($CONTENT_FILE);
   
   my $id = params->{'msg_id'};
   my $real_id = substr $id, 1, length($id);
   $real_id--;
    
   my $get_all_comments = $data->{"content"}[$real_id]{"fields"}{comments};
   my $return_value;
   foreach (@$get_all_comments) {
      $return_value = $return_value  . " <p>$_->{comment_text} - posted by $_->{comment_by}</p>";
   }
   
   return $return_value;
   #print $return_value;
    
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
    $db->begin_work();
    my $sql = "select * from login where username=? AND password=?";
    my $sth = $db->prepare($sql);
    $sth->execute(params->{'username'}, params->{'password'});
    my $user = $sth->fetch;
    $db->commit();
    if (!$user) {
         template '__login';
     } else {
         session logged_in => 1;
         session username => params->{'username'};
         
         redirect '/';
     }
};

true;
