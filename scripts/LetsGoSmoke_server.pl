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

my $config = Config::JSON->new( 'LetsGoSmoke.conf' );
my $dbClient = MongoDB::MongoClient->new( %{ $config->get('mongodb') } )->get_database( 'LetsGoSmoke' );

my $socket = IO::Socket::INET->new( %{ $config->get('server') } ) or die "Error in socket creation: $!\n";

my $letsGoSmoke = LetsGoSmoke->new( dbClient => $dbClient );

#example request message
#{
#    from => smoker,
#    to => [
#        "user1",
#        "user2",
#    ],
#    request => {
#        offer => 1,
#        type => "smoke",
#    },
#}

while ( 1 ) {
    my $client_socket = $socket->accept();
    my $connectionInfo = {
        host => $client_socket->peerhost(),
        port => $client_socket->peerport(),
    };
    $letsGoSmoke->set_connectionInfo( $connectionInfo );

    my $data = undef;

    $client_socket->recv( $data, 1024 );
    warn Dumper $data;
    $letsGoSmoke->set_requestMessage( $data );
    my $response = $letsGoSmoke->processRequest();

    $client_socket->send( $response );
    $letsGoSmoke->clear_temp_vars();
    $client_socket->close();
}

$socket->close();

1;
