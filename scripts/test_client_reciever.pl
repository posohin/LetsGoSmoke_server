#!/usr/bin/perl

use warnings;
use strict;

use IO::Socket::INET;
use Data::Dumper;
use JSON;

$| = 1;

my $socket = new IO::Socket::INET (
PeerHost => '127.0.0.1',
PeerPort => 5000,
LocalHost => '10.15.8.11',
LocalPort => 5228,
Proto => 'tcp',
) or die "ERROR in Socket Creation : $!\n";

warn "TCP Connection Success.\n";

my $data = {
    from => "reciever_client",
    request => {
        status => "Hello, world!",
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
$socket->close();


my $listen_socket = new IO::Socket::INET (
LocalPort => 5228,
LocalHost => '10.15.8.11',
Proto => 'tcp',
ReuseAddr => 1,
Listen => 10
) or die "ERROR in Socket Creation : $!\n";
$data = undef;
while ( 1 ) {
    my $server_socket = $listen_socket->accept();
    $server_socket->recv($data, 1024);
    warn Dumper $data;
}
