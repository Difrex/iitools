#!/usr/bin/env perl 

use HF::Fetch;
use HF::Enc;
use HF::Send;

use Data::Dumper;

# Configuration
###############

# Sqlite DB
my $data = './data/db.sql';

# ii setup
my $ii = {
    # ii node auth string
    auth => '',
    # ii url with /
    ii_node_url => '',
    # ii echo
    ii_echo => '',
};

# Hanra RSS Feed
my $feed = '';

# End of configuration
######################

my $hf  = HF::Fetch->new($feed);
my @rss = $hf->fetch;

my $enc_d = {
    db => $data,
    echo => $ii->{ii_echo},
};

my $enc = HF::Enc->new( $enc_d );
my @new_messages = $enc->encode(@rss);

# Send messages
my $send = HF::Send->new($ii);
$send->send(@new_messages);

