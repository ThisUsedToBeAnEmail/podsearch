package podsearch;
use Dancer2;
use Dancer2::Plugin::DBIC;
use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
    my $module = schema->resultset('Module')->first;
    warn Dumper $module->name;
    template 'index', {
        add_module_url => uri_for('/module'),   
    };
};

post '/module' => sub {
    my $something = schema->resultset('Module');
    $something->generate_pod(params->{'title'});
    redirect '/'; 
};

true;
