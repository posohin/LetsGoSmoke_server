package LetsGoSmoke;

use version; our $VERSION = version->parse("0.01_00");

use Moose;
use namespace::autoclean;

use LetsGoSmoke::Model::Users;
use LetsGoSmoke::Model::Status;
use LetsGoSmoke::Controller::Status;
use LetsGoSmoke::Controller::Offer;
use LetsGoSmoke::Controller::Confirmation;

use JSON;

has 'dbClient' => (
    is          => 'ro',
    isa         => 'MongoDB::MongoClient',
    required    => 1,
);

has 'requestMessage' => (
    is          => 'ro',
    isa         => 'Str',
    writer      => 'set_requestMessage',
    clearer     => '_clear_requestMessage',
);

has 'connectionInfo' => (
    is          => 'ro',
    isa         => 'HashRef',
    writer      => 'set_connectionInfo',
    clearer     => '_clear_connectionInfo',
);

has 'from' => (
    is          => 'ro',
    isa         => 'HashRef',
    writer      => '_set_from',
    clearer     => '_clear_from',
);

has 'to' => (
    is          => 'ro',
    isa         => 'ArrayRef[HashRef]',
    writer      => '_set_to',
    clearer     => '_clear_to',
);

has 'controller' => (
    is          => 'ro',
    isa         => 'LetsGoSmoke::Controller::Base'
    writer      => '_set_controller',
    clearer     => '_clear_controller',
);

sub processRequest {
    my $self = shift;

    $self->parseRequestMessage();
    my $response = $self->controller->processRequest();

    return $response;
}

sub parseRequestMessage {
    my $self = shift;

    $self->clear_temp_vars;

    my $request = from_json( $self->requestMessage );
    my $userModel = LetsGoSmoke::Model::Users->new( dbClient => $self->dbClient );

    #set 'from' user
    my $from = userModel->find(
        username => $request->{from},
        host => $self->connectionInfo->{host},
        port => $self->connectionInfo->{port},
    ); #get new or exists user hashref
    $self->set_from( $from );

    #set 'to' users
    if ( defined $request->{to} and ref $request->{to} eq "ARRAY" ) {
        my @to = ();
        foreach my $username ( @{ $request->{to} } ) {
            my $userModel = userModel->get( username => $username );
            push @to, $userModel if defined userModel;
        }
        self->set_to( \@to );
    } elsif ( defined $request->{to} and ref $request->{to} eq "SCALAR" ) {
        my $to = userModel->get( username => $username ); #get user hashref
        $self->set_to( [$to] );
    }

    #choose handler
    if ( exists $request->{request}->{status} ) {
        $self->set_controller( LetsGoSmoke::Controller::Status->new(
                from => $self->from,
                to => $self->to,
                request => $request->{request},
                dbClient => $self->dbClient,
            )
        );
    } elsif ( exists $request->{request}->{offer} ) {
        $self->set_controller( LetsGoSmoke::Controller::Offer->new(
                from => $self->from,
                to => $self->to,
                request => $request->{request},
                dbClient => $self->dbClient,
            )
        );
    } elsif ( exists $request->{request}->{confirmation} ) {
        $self->set_controller( LetsGoSmoke::Controller::Confirmation->new(
                from => $self->from,
                to => $self->to,
                request => $request->{request},
                dbClient => $self->dbClient,
            )
        );
    }
}

sub clear_temp_vars {
    my $self = shift;

    $self->clear_from;
    $self->clear_to;
    $self->clear_requestMessage;
    $self->clear_connectionInfo;
    $self->clear_controller;
}

__PACKAGE__->meta->make_immutable;

1;