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
   
    my $search_text = $query; 
    my @results; 
    if ( length $query ) {
        my $module;
        
        if ($query =~ s{m:}{}){
            ($module, $query) = split(/\s/, $query, 2);         
        }

        @results = _perform_search({
            class => 'Pod', 
            query => $query, 
            module => $module
        });
    }
    
    template 'search', {
        search_text => $search_text,
        search_results => \@results,
        search_pod_url => uri_for('/search'),
    };
};

get '/module_list' => sub {
    my $query = params->{'query'};
    
    my @modules;
    
    if ($query) {
        @modules = _perform_search({
            class => 'Module',
            query => $query,
        });
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
    my ($args) = @_;
 
    warn Dumper $args->{class}; 
    my $rs = schema->resultset($args->{class});

    if (my $module = $args->{module}) {
        my @pod = schema->resultset('Module')->pgfulltext_search($module)->all;
        my @pod_ids = map { $_->id } @pod;
        
        $rs = $rs->search({ module_id => { -in => \@pod_ids } }, { order_by => 'id' }); 
    }

    if (my $query = $args->{query}) {
        $rs = $rs->pgfulltext_search($query, 
            { 
                normalisation => { length => 1 },
            },   
        );
    }

    return $rs->all;
}

true;
