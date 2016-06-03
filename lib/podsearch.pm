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
    warn Dumper $module->name;
    template 'index', {
        'msg' => get_flash(),
        add_module_url => uri_for('/module'),   
    };
};

post '/module' => sub {
    my $message = schema->resultset('Module')->generate_pod(params->{'title'});
    set_flash($message);
    redirect '/'; 
};

true;
