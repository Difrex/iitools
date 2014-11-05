package HF::Send;

use LWP::UserAgent;
use MIME::Base64;

sub new {
    my $class = shift;

    my $self = {
        _config => shift,
    };

    bless $self, $class;
    return $self;
}

sub send {
    my ( $self, @messages ) = @_;
    my $echo    = $self->{_config}->{echo};
    my $auth    = $self->{_config}->{auth};
    my $url     = $self->{_config}->{ii_node_url};

    # Push message to server
    $host = $url . "u/point";
    my $ua = LWP::UserAgent->new();
    foreach my $message (@messages) {
        $message =~ s/\//_/g;
        $message =~ s/\+/-/g;
        my $response
            = $ua->post( $host, { 'pauth' => $auth, 'tmsg' => $message } );

        if ( $response->{_rc} == 200 ) {
            print "Message send out\n";
        }
    }
}

1;
