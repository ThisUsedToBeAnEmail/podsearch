package Pod::Hashed;
use Pod::Simple;
@ISA     = qw(Pod::Simple);
$VERSION = '1.01';

use 5.006;
use Moo;

has 'pod' => (
    is      => 'rw',
    lazy    => 1,
    default => sub { [] },
);

has 'section' => (
    is      => 'rw',
    lazy    => 1,
    default => sub { {} },
);

has 'title_elements' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        return {
            'head1' => 1,
            'head2' => 1,
            'head3' => 1,
            'head4' => 1
        };
    },
);

has 'content_elements' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        return {
            'Para'      => 1,
            'item-text' => 1,
            'over-text' => 1,
            'Verbatim'  => 1,
            'C'         => 1,
            'L'         => 1,
            'B'         => 1,
            'I'         => 1
        };
    }
);

has 'element_name' => (
    is      => 'rw',
    default => q{},
);

sub get {
    my ( $self, $index ) = @_;
    my @pod = $self->pod;
    return $pod[0][$index];
}

sub pod_aoh {
    my $self = shift;
    my @pod  = $self->pod;
    return @{ $pod[0] };
}

sub _handle_element_start {
    my ( $parser, $element_name, $atrr_hash_r ) = @_;

    $parser->element_name($element_name);
    if ( $parser->title_elements->{$element_name} ) {

        if ( $parser->section->{title} && $parser->section->{identifier} ) {
            $parser->_insert_pod;
        }

        if ( !$parser->section->{identifier} ) {
            $parser->section->{identifier} = $element_name;
        }
    }
}

sub _handle_text {
    my ( $parser, $text ) = @_;

    my $element_name = $parser->element_name;
    if ( $parser->content_elements->{$element_name} ) {

        if ( my $para = $parser->section->{content} ) {

            if ( $element_name =~ m{item-text|over-text} ) {
                $parser->section->{content} = $para . "\n\n" . $text . "\n\n";
            }
            # expecting either a new paragragh or code example
            elsif ( $para =~ /[\.\;\:\*]$/ ) {
                $parser->section->{content} = $para . "\n\n" . $text;
            }
            
            else {
                $parser->section->{content} = $para . $text;
            }
        }

        # else set content
        else {
            $parser->section->{content} = $text;
        }
    }
    elsif ( $parser->title_elements->{$element_name} ) {
        $parser->section->{title} = $text;
    }
}

sub _handle_element_end {
    my ( $parser, $element_name, $attr_hash_r ) = @_;

    if ( $parser->source_dead ) {
        $parser->_insert_pod
          if $parser->section->{title}
          && $parser->section->{identifier};
    }
}

sub _insert_pod {
    my $self = shift;

    push $self->pod, $self->section;
    return $self->section( {} );
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

    @pod_aoh = $parser->pod_aoh;
    $pod_name = $parser->get(0);

    $pod_name->{title};

=head1 DESCRIPTION

Parse POD into an array of hashes

    {
        identifier => 'head1',
        title => NAME,
        content => 'Some::Module - you get this too'
    },
    ......

=over

=back

