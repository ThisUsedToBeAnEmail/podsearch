package podsearch;
use Dancer2;
use Dancer2::Plugin::DBIC;
use Data::Dumper;

our $VERSION = '0.1';
my $flash;

sub set_flash {
    my $message = shift;

    $flash = $message;
}

sub get_flash {
    my $msg = $flash;
    $flash = "";
    return $msg;
}

get '/' => sub {
    my $module = schema->resultset('Module')->first;
    template 'index', {
        'msg' => get_flash(),
        add_module_url => uri_for('/module'),   
        search_pod_url => uri_for('/search'),
    };
};

post '/module' => sub {
    my $message = schema->resultset('Module')->generate_pod(params->{'title'});
    set_flash($message);
    redirect '/'; 
};

get '/search' => sub {
    my $query = params->{'query'};
    my @results; 

    if ( length $query ) {
        @results = _perform_search($query);
    }
    
    template 'index', {
        query => $query,
        search_results => \@results,
    };
};

sub _perform_search {
    my $query = shift;

    my @search_rs = schema->resultset('Pod')->search({
        -or => [
            title => { like => "%$query%" },
            content => { like => "%$query%" },
        ]
    });
    
    return @search_rs;
}

true;
