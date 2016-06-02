package Pod::Hashed;
use base qw(Pod::Simple::PullParser);

use 5.006;
use Moose;
use Data::Dumper;
use Carp;

has 'pod' => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef',
    lazy => 1,
    default => sub { [ ] },
    handles => {
        add_section => 'push',    
        pod_aoh => 'elements',
        get => 'get'
    }
);

has 'section' => (
    traits => ['Hash'],
    is => 'rw',
    isa => 'HashRef',
    lazy => 1,
    default => sub { { } },    
    handles => {
        section_clear => 'clear',
        set_section => 'set',
    }
);

sub run  {
    my $self = shift;
    
    my ($tag, $text, $identifier, $title, $para);
    my %valid_tags = ( head1 => 1, head2 => 1,  Para => 1,  item => 1);
    while ( my $token = $self->get_token ) {
        if ( $token->isa('Pod::Simple::PullParserStartToken') ) {    
            if (exists $valid_tags{$token->tagname}) {
                $tag = $token->tagname;
                
                next if $tag eq q{Para};

                if (!$identifier) { 
                    # set the identifier on the first tag
                    $identifier = $tag;
                }

                if ($title && $tag){
                    $self->set_section(
                        identifier => $identifier,
                        title => $title, 
                        content => $para
                    );

                    $self->insert_pod;
                    ($title, $para, $identifier) = undef;
                }
            }
        } 
        elsif ( $token->isa('Pod::Simple::PullParserTextToken') ) {
            $text = $token->text;
        } 
        elsif ( $token->isa('Pod::Simple::PullParserEndToken') ) {
            if ( $tag && $text ) { 
                if ($tag eq 'Para') {
                    $para = $para ? $para . "\n" . $text : $text;
                } else {
                    $title = $text;
                }
            }
        } 
    }
}

sub insert_pod {
    my ( $self ) = @_;

    my $section = $self->section;

    $self->add_section($section);

    return $self->section_clear;
}

1; 

__END__

=head1 NAME

Pod::Hashed

=head1 VERSION

Version 0.1

=head1 SYNOPSIS 

    use Pod::Simple::Hashed;
    my $parser = Pod::Hashed->new();

    $parser->parse_from_file( 'perl.pod' );

    $pod_aoh = $parser->pod_aoh;
    $pod_name = $parser->get(0);

    $pod_name->{title};

=head1 DESCRIPTION

Kinda Parse POD into an array of hashes?

    {
        identifier => 'head1',
        title => NAME,
        content => 'Some::Module - you get this too'
    },
    ......

=over

=back


# End of Pod::ToHash
