#!/usr/bin/perl

use warnings;
use strict;

use LetsGoSmoke;

use IO::Socket::INET;
use JSON;
use Getopt::Long::Descriptive;
use Config::JSON;
use Data::Dumper;

$| = 1;

my $config = Config::JSON->new('t/LetsGoSmoke.conf');
my %states = reverse %{ $config->get('states') };

my $socket = IO::Socket::INET->new(
    LocalPort   => '5000',
    LocalHost   => '127.0.0.1',
    Proto       => "tcp",
    ReuseAddr   => 1,
    Listen      => 10,
) or die "Error in socket creation: $!\n";

my $lets_go_smoke = LetsGoSmoke->new( states => \%states );

while ( 1 ) {
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
