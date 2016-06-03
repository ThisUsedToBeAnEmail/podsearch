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
    my %valid_tags = ( 'head1' => 1, 'head2' => 1,  'Para' => 1, 'over-text' => 1, 'item-text' => 1, 'Verbatim' => 1);
    my %text_tags = (  'Para' => 1,  'item-text' => 1, 'over-text' => 1, 'Verbatim' => 1, 'C' => 1, 'L' => 1, 'B' => 1, 'I' => 1 );
    while ( my $token = $self->get_token ) {
        if ( $token->isa('Pod::Simple::PullParserStartToken') ) {    
            $tag = $token->tagname;
            if (exists $valid_tags{$tag}) {
                next if exists $text_tags{$tag};

                if ($title && $identifier){
                    $self->set_section(
                        identifier => $identifier,
                        title => $title, 
                        content => $para
                    );

                    $self->insert_pod;
                    ($title, $para, $identifier) = undef;
                }

                if (!$identifier) { 
                    # set the identifier on the first tag
                    $identifier = $tag;
                }
            }
        } 
        elsif ( $token->isa('Pod::Simple::PullParserTextToken') ) {
            $text = $token->text;
            if (exists $text_tags{$tag}) {        
                if ($para) {
                    if ($tag =~ m{item-text|over-text}){
                        $para = $para . "\n\n" . $text . "\n\n";
                    }
                    elsif ($para =~ /[\.\;\:]$/) {
                        $para = $para . "\n\n" . $text;
                    } 
                    else {
                        $para = $para . $text;
                    }
                } 
                else {
                    $para = $text;
                }
            } 
            else {
                $title = $text;
            }
        } 
        elsif ( $token->isa('Pod::Simple::PullParserEndToken') ) {
        
        } 
    }

    if ($title && $identifier){
        $self->set_section(
            identifier => $identifier,
            title => $title, 
            content => $para
        );

        $self->insert_pod;
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
