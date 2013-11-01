#!/usr/bin/perl

use warnings;
use strict;

use IO::Socket::INET;
use JSON;
use Data::Dumper;

$| = 1;

my $socket = IO::Socket::INET->new(
    LocalPort   => '5000',
    LocalHost   => '127.0.0.1',
    Proto       => "tcp",
    ReuseAddr   => 1,
    Listen      => 10,
) or die "Error in socket creation: $!\n";


while (1) {
    my $client_socket = $socket->accept();
    my $peer_address = $client_socket->peerhost();
    my $peer_port = $client_socket->peerport();
    warn "Accepted New Client Connection From : $peer_address, $peer_port\n";

    my $data = '{"type":"hello_message"}';

    $client_socket->send($data);
    $client_socket->recv($data, 1024);
    $data = from_json( $data );
    warn Dumper $data;
}
$socket->close();
