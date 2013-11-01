#!/usr/bin/perl

use warnings;
use strict;

use IO::Socket::INET;
use Data::Dumper;

$| = 1;

my $socket = new IO::Socket::INET (
PeerHost => '127.0.0.1',
PeerPort => '5000',
Proto => 'tcp',
) or die "ERROR in Socket Creation : $!\n";

warn "TCP Connection Success.\n";

my $data;
$socket->recv($data, 1024);
warn Dumper $data;

$data = '{"type":"simple_client_answer"}';
$socket->send($data);

sleep (10);
$socket->close();