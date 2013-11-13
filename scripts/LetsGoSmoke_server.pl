#!/usr/bin/perl

use warnings;
use strict;

use LetsGoSmoke;

use IO::Socket::INET;
use Getopt::Long::Descriptive;
use Config::JSON;
use MongoDB;
use Data::Dumper;

$| = 1;

my $config = Config::JSON->new( '../conf/LetsGoSmoke.conf' );
my $mongoClient = MongoDB::MongoClient->new( %{ $config->get('mongodb') } );

my $socket = IO::Socket::INET->new( %{ $config->get('server') } ) or die "Error in socket creation: $!\n";

my $letsGoSmoke = LetsGoSmoke->new( dbClient => $mongoClient );

while ( 1 ) {
    my $client_socket = $socket->accept();
    my $connectionInfo = (
        host => $client_socket->peerhost(),
        port => $client_socket->peerport(),
    );
    $letsGoSmoke->set_connectionInfo( $connectionInfo );

    my $data = '{"type":"hello_message"}';

    $client_socket->send( $data );

    $client_socket->recv( $data, 1024 );
    $letsGoSmoke->set_requestMessage( $data );
    my $response = $letsGoSmoke->processRequest();

    $client_socket->send( $response );
    $client_socket->close();
}

$socket->close();

1;
