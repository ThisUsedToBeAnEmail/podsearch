#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Data::Dumper;

BEGIN {
    use_ok( 'Pod::Hashed' ) || print "Bail out!\n";
}

subtest 'hash options' => sub {
     test_value({
        get => 0,
        identifier => 'head1',
        html_content => '<div><p>HTML::SocialMeta - Module to generate Social Media Meta Tags,</p></div>',
        html_title => '<h1>NAME</h1>',
    }); 
    test_value({
        get => 5,
        identifier => 'head2',
        html_title => '<h1>Constructor</h1>',
        html_content => q{<div><p>Returns an instance of this class. Requires <pre><span>$url</span></pre> as an argument;</p><h5>card</h5><p>OPTIONAL - if you always want the same card type you can set it</p><h5>site</h5><p>The Twitter @username the card should be attributed to. Required for Twitter Card analytics.</p><h5>site_name</h5><p>This is Used by Facebook, you can just set it as your organisations name.</p><h5>title</h5><p>The title of your content as it should appear in the card</p><h5>description</h5><p>A description of the content in a maximum of 200 characters</p><h5>image</h5><p>A URL to a unique image representing the content of the page</p><h5>url</h5><p>OPTIONAL OPENGRAPH - allows you to specify an alternative url link you want the reader to be redirected</p><h5>player</h5><p>HTTPS URL to iframe player. This must be a HTTPS URL which does not generate active mixed content warnings in a web browser</p><h5>player_width</h5><p>Width of IFRAME specified in twitter:player in pixels</p><h5>player_height</h5><p>Height of IFRAME specified in twitter:player in pixels</p><h5>operating_system</h5><p>IOS or Android</p><h5>app_country</h5><p>UK/US ect</p><h5>app_name</h5><p>The applications name</p><h5>app_id</h5><p>String value, and should be the numeric representation of your app ID in the App Store (.i.e. 307234931)</p><h5>app_url</h5><p>Application store url - direct link to App store page</p><h5>fb_app_id</h5><p>This field is required to use social meta with facebook, you must register your website/app/company with facebook. They will then provide you with a unique app_id.</p></div>},    
    }); 
};

done_testing();

sub test_value {
    my $args = shift;

    my $parser = Pod::Hashed->new();
    $parser->parse_from_file( 't/data/social-meta.pod' );

    my $values = $parser->get($args->{get});
    
    my @fields = qw(identifier html_content html_title);
    foreach my $field (@fields) {
        is($values->{$field}, $args->{$field}, "correct value for $field - get $args->{get}");
    }
}

1;
