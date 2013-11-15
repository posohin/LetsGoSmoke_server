#!/usr/bin/perl

use warnings;
use strict;

use IO::Socket::INET;
use Data::Dumper;
use JSON;

$| = 1;

my $socket = new IO::Socket::INET (
PeerHost => '127.0.0.1',
PeerPort => '5000',
Proto => 'tcp',
) or die "ERROR in Socket Creation : $!\n";

warn "TCP Connection Success.\n";

my $data = {
    from => "test_client",
    request => {
        status => 1,
    },
};
my $message = to_json($data);
#$socket->recv($data, 1024);
#warn Dumper $data;
warn Dumper $message;
$socket->send($message);
my $response = undef;
$socket->recv($response, 1024);
warn Dumper $response;
