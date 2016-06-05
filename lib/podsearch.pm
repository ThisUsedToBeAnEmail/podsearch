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
        'msg' => get_flash(),
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
        module_list => \@modules,
        search_module_url => uri_for('/module_list'),
    };  
};

post '/add_module' => sub {
    my $message = schema->resultset('Module')->generate_pod(params->{'title'});
    set_flash($message);
    redirect '/search?query=m:' . params->{'title'}; 
};

sub _perform_search {
    my ($args) = @_;
    my $query = $args->{query}; 
    
    my $rs = schema->resultset($args->{class});
    my (%where, %attributes) = ();

    if (my $module = $args->{module}) {
        my @pod = schema->resultset('Module')->pgfulltext_search($module)->all;
        my @pod_ids = map { $_->id } @pod;
        
        $where{module_id} = { -in => \@pod_ids };
        $attributes{order_by} = 'default_order';
    }

    if ($args->{class} eq q{Pod}){

        my @ignore = ( 
            'NAME', 
            'VERSION', 
            'AUTHOR', 
            'DIAGNOSTICS', 
            'INCOMPATIBILITIES', 
            'LICENSE AND COPYRIGHT' 
        );

        # remove NAME attributes from rs as they're useless in search
        $where{title} = { '-not in' => \@ignore };
    }

    $rs = $rs->search(\%where, \%attributes);

    return $rs->all if !$query; 

    $rs = $rs->pgfulltext_search( $query, 
        { 
            normalisation => { rank => 1, log_unique_words => 1 },
        },   
    );

    return $rs->all;
}

true;
