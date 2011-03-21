package portfolio;
use Template;
use Dancer;
use Dancer::Plugin::Database;
use Data::Dumper;
use YAML::Syck;
use CGI;

our $VERSION = '0.1';

sub connect_db {
    my $dbh = DBI->connect("dbi:SQLite:dbname=webdata") or
       die $DBI::errstr;

    return $dbh;
}

get '/' => sub {
    my $data = LoadFile('content.yml');
    template 'index', {'content' => $data};
};
post '/save' => sub {
  return params->{'value'};
};

get '/edit_mode' => sub {
  if (session('logged_in')) {
    if (session('edit_mode')) {
       redirect '/?save=true';
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
