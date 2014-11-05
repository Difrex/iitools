package HF::Fetch;

use strict;
use warnings;
 
use XML::FeedPP;

sub new {
    my $class = shift;
    
    my $rss_url = shift;
    my $feed    = XML::FeedPP->new( $rss_url );
    
    my $self = {
        _feed     => $feed,
    };

    bless $self, $class;
    return $self;
}

sub fetch {
    my ($self) = @_;
    my $feed = $self->{_feed};

    my @items = $feed->{rss}->{channel}->{item};
    
    my @data;
    foreach my $item (@items) {
        foreach my $i (@$item) {
            my $title = $i->{title};
            my $description = $i->{description};
            
            next if $title =~ m/\[Из.+\].+/;

            $description =~ s/<br\/>/\n/g;
            $description =~ s/<a href="(.+)">(.+)<\/a>/$2($1)/g;
            $description =~ s/&.+;//g;
            $description =~ s/<img src="\/\/(.+)"\/>/$1/g;
            $description =~ s/<.+>(.+)<\/.+>/$1/g;

            push( @data, {title => $title, body => $description} );
        }
    }
    
    return @data;
}

1;
