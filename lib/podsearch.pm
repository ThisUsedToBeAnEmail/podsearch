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
   redirect '/search';
};

get '/generate' => sub {
    template 'generate', {
        'msg' => get_flash(),
        add_module_url => uri_for('/add_module'),   
    };
};

get '/search' => sub {
    my $query = params->{'query'};
    my @results; 

    if ( length $query ) {
        @results = _perform_search('Pod', $query);
    }
    
    template 'search', {
        query => $query,
        search_results => \@results,
        search_pod_url => uri_for('/search'),
    };
};

get '/module_list' => sub {
    my $query = params->{'query'};
    
    my @modules;
    if ($query) {
        @modules = _perform_search('Module', $query);
    } else {
        @modules = schema->resultset('Module')->all;
    }

    template 'module_list', {
        'msg' => get_flash(),
        module_list => \@modules,
        search_module_url => uri_for('/module_list'),
    };  
};


post '/add_module' => sub {
    my $message = schema->resultset('Module')->generate_pod(params->{'title'});
    set_flash($message);
    redirect '/module_list'; 
};

sub _perform_search {
    my ($class, $query) = @_;

    my @search_rs = schema->resultset($class)->pgfulltext_search($query, 
        { 
            normalisation => { length => 1 },
        },   
    );

    return @search_rs;
}

true;
