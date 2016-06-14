package Pod::Hashed;
use Pod::Simple;
@ISA     = qw(Pod::Simple);
$VERSION = '1.01';

use 5.006;
use Moo;
use HTML::Element;
use Data::Dumper;

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
            'head1' => ['h1'],
            'head2' => ['h2'],
            'head3' => ['h3'],
            'head4' => ['h4']
        };
    },
);

has 'content_elements' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        return {
            'Para'      => { tags => { wrapper_tag => 'p' } },
            'item-text' => { tags => { wrapper_tag =>'h5' } },
            'over-text' => { tags => { wrapper_tag =>'h5' } },
            'Verbatim'  => { tags => { wrapper_tag => 'pre', element_tag => 'div' } },
            'Data'      => { tags => { wrapper_tag => 'pre', element_tag => 'div' } },
            'C'         => { tags => { wrapper_tag => 'pre', element_tag => 'span', embed => 1 } },
            'L'         => { tags => { wrapper_tag => 'a', embed => 1 } },
            'B'         => { tags => { wrapper_tag => 'b', embed => 1 } },
            'I'         => { tags => { wrapper_tag => 'i', embed => 1 } },
            'E'         => { tags => { wrapper_tag => 'span', embed => 1 } },
            'F'         => { tags => { wrapper_tag => 'pre', element_tag => 'span', embed => 1 } },
            'S'         => { tags => { wrapper_tag => 'pre', element_tag => 'span', embed => 1 } },
            'X'         => { tags => { wrapper_tag => 'h5' } },
            'join'      => { tags => { embed => 1 } },
        };
    }
);

has 'element_name' => (
    is      => 'rw',
    clearer => 1,
    default => q{},
    
);

has 'html_end_tags' => (
    is => 'rw',
    lazy => 1,
    default => sub { [ ] },
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
    
    my $element_name = $parser->element_name || 'join';
    $parser->clear_element_name;
    if (defined $parser->content_elements->{$element_name} ) {
        my $element = $parser->content_elements->{$element_name};
        my $element_args = {
            text => $text,
            element_name => $element_name,
            content => $parser->section->{content},
            html_content => $parser->section->{html_content},
            tags => $element->{tags},
        };
        
        $parser->section->{content} = $parser->_parse_text('content', $element_args);
        $parser->section->{html_content} = $parser->_parse_into_html_content($element_args);
    }
    elsif ( $parser->title_elements->{$element_name} ) {
        $parser->section->{title} = $text;
        $parser->section->{html_title} = sprintf('<h1>%s</h1>', $text);
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
    my $parser = shift;
   
    if (my $html_content = $parser->section->{html_content}){ 
        $html_content = $parser->_close_html_tags({ 
            html_content => $html_content 
        });
        $parser->section->{html_content} = $parser->_close_html_tags({
            html_content => $html_content
        });
    }
    
    push $parser->pod, $parser->section; 
    return $parser->section( {} );
}

sub _parse_text {
    my ($parser, $type, $element_args) = @_;
    if (my $content = $element_args->{$type}) {
        if ( $element_args->{element_name} =~ m{item-text|over-text} ) {
            return $content . "\n\n" . $element_args->{text} . "\n\n";
        }
        # expecting either a new paragragh or code example
        elsif ( $content =~ /[\.\;\:\*]$/ ) {
            return $content . "\n\n" . $element_args->{text};
        }
            
        else {
            return $content . $element_args->{text};
        }
    } else {
        return $element_args->{text};
    }
}

sub _parse_into_html_content {
    my ($parser, $element_args) = @_;

    return $parser->_hack_the_links($element_args)
        if $element_args->{element_name} eq 'L';
    
    if (my $html_content = $element_args->{html_content}) {
        return $parser->_join_html_tags($element_args);      
    }
    else {
        return $parser->_open_html_tags($element_args);
    }
}

has 'content_wrapper_tag' => (
    is => 'ro',
    default => 'div',
);

sub _open_html_tags {
    my ($parser, $element_args) = @_;
    
    my $tags = $element_args->{tags};
    my $element = $element_args->{element_name};
    my $text = $element_args->{text};
    my $wrapper_tag = $tags->{wrapper_tag};
    my $element_tag = $tags->{element_tag};

    push $parser->html_end_tags, {tags => $tags, element => $element};
    if (my $html_content = $element_args->{html_content}){
        if ($element_tag) {
            return sprintf('%s<%s><%s>%s',
                $html_content, $wrapper_tag, $element_tag, $text);
        }
        else {
            return sprintf('%s<%s>%s',
                $html_content, $wrapper_tag, $text);
        }    
    }
    else {
        if ($element_tag) {
            return sprintf('<%s><%s><%s>%s', 
                $parser->content_wrapper_tag, $wrapper_tag, $element_tag, $text);
        } 
        else {
            return sprintf('<%s><%s>%s', 
                $parser->content_wrapper_tag, $wrapper_tag, $text);
        }
    };
}

sub _join_html_tags {
    my ($parser, $element_args) = @_;

    my $tags = $element_args->{tags};
    my $element = $element_args->{element_name};
    my $text = $element_args->{text};
    
    # get the last elements tags but keep it stored
    push $parser->html_end_tags, my $last_end_tag = pop $parser->html_end_tags;
    # if the tags are the same but not a Para - just join
    if ($last_end_tag->{tags}{embed} && $element eq $last_end_tag->{element}){
        return $parser->_just_join_the_html_text($element_args->{html_content}, $text);
    }

    # if the content is embeded check - content_elements
    if ($tags->{embed}){
        if ($last_end_tag->{tags}{embed}) {
            $element_args->{html_content} = $parser->_close_html_tags($element_args);
            return $parser->_just_join_the_html_text($element_args->{html_content}, $text)
                if $element eq 'join';
        }
        
        return $parser->_open_html_tags($element_args);
    }

    # else we need to close the current html tag
    $element_args->{html_content} = $parser->_close_html_tags($element_args);
    return $parser->_open_html_tags($element_args);    
}

sub _close_html_tags {
    my ($parser, $element_args) = @_;
   
    my $end_tags = pop $parser->html_end_tags;
    my $tags = $end_tags->{tags};
    if ( my $element_tag = $tags->{element_tag} ) {
        
        my $html_content =  sprintf('%s</%s></%s>', 
            $element_args->{html_content}, $element_tag, $tags->{wrapper_tag});
        
        return $element_args->{tags}{embed}
            ? $html_content
            : $parser->_final_close($html_content);
    } 
    else {
        
        my $tag =  $tags->{wrapper_tag} || $parser->content_wrapper_tag;
        my $html_content = sprintf('%s</%s>', $element_args->{html_content}, $tag);
    
        return $element_args->{tags}{embed} 
            ? $html_content 
            : $parser->_final_close($html_content);
    }
}

# should probs be doing some recursion above - i'll come back
sub _final_close {
    my ($parser, $html_content) = @_;
    
    my $end_tag = pop $parser->html_end_tags;
    return $html_content unless $end_tag;
    return sprintf('%s</%s>', $html_content, $end_tag->{tags}{wrapper_tag});
}

sub _just_join_the_html_text {
    my ($parser, $html_content, $text) = @_;

    my $spaced = $text =~ /^\W/ ? '%s%s' : '%s %s';
    return sprintf($spaced, $html_content, $text);
}

sub _hack_the_links {
    my ($parser, $args) = @_;

    push $parser->html_end_tags, {tags => $args->{tags}, element => $args->{element_name}};
    if ($args->{text} =~ m{^[http]|\:\:}){
        my $start = $args->{html_content} ? $args->{html_content} : q{<div>};
        return sprintf('%s<a href="%s">%s',
            $start, $args->{text}, $args->{text});
    }
    return $parser->_just_join_the_html_text($args->{html_content}, $args->{text});
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
        content => 'Some::Module - you get this too',
        html_content => '<p><a>Some::Module</a> - you get this too</p>,
        html_title => <h2>Name<h2>,
    },
    ......

=over

=back

