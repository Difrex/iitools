package HF::Enc;

use HF::DB;
use MIME::Base64;
use Digest::MD5 qw(md5_hex);

use Data::Dumper;

sub new {
    my $class = shift;
    
    my $data    = shift;

    my $db      = HF::DB->new( $data->{db} );

    my $self = {
        _db     => $db,
        _echo   => $data->{echo},
    };

    bless $self, $class;
    return $self;
}


sub encode {
    my ( $self, @rss ) = @_;
    my $db      = $self->{_db};
    my $echo    = $self->{_echo};
    
    $db->begin();
    my @new_messages;
    foreach my $item (@rss) {
        my $title   = $item->{title};
        my $body    = $item->{body};
    
        # Check md5 
        my $md5 = HF::Enc->md5_hash($title);
        if ( $db->check_md5($md5) == 0 ) {

            # Make base64 message
            my $message .= $echo . "\n";
            $message .= 'All' . "\n";
            $message .= $title . "\n\n";
            $message .= "\n";
            $message .= $body;

#            my $encoded = `echo '$message' | base64`;
            my $encoded = encode_base64($message);
#            $encoded =~ s/\//_/g;
#            $encoded =~ s/\+/-/g;

            # Make data
            my $out = {
                base64  => $encoded,
                id     => $md5,
            };

            $db->write($out);

            push( @new_messages, $encoded );
        }
    }
    
    $db->commit();
    return @new_messages;
}

sub md5_hash {
    my ( $self, $title ) = @_;
    my $md5 = md5_hex( $title ) ;

    return $md5;
}

1;
