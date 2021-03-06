package LetsGoSmoke;

use version; our $VERSION = version->parse("0.01_00");

use Moose;
use namespace::autoclean;

use LetsGoSmoke::Model::Users;
use LetsGoSmoke::Controller::Status;
use LetsGoSmoke::Controller::Offer;
use LetsGoSmoke::Controller::Confirmation;

use JSON;
use Data::Dumper;

has 'dbClient' => (
    is          => 'ro',
    isa         => 'MongoDB::Database',
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

has 'request' => (
    is          => 'ro',
    isa         => 'HashRef',
    writer      => '_set_request',
    clearer     => '_clear_request',
);

has 'controller' => (
    is          => 'ro',
    isa         => 'LetsGoSmoke::Controller::Status|LetsGoSmoke::Controller::Offer|LetsGoSmoke::Controller::Confirmation',
    writer      => '_set_controller',
    clearer     => '_clear_controller',
);

sub processRequest {
    my $self = shift;

    $self->parseRequestMessage();
    my $response = to_json({
        to      => $self->controller->processRequest(),
        from    => $self->from->{username},
        request => $self->request->{request},
    });

    return $response;
}

sub parseRequestMessage {
    my $self = shift;

    $self->_set_request( from_json( $self->requestMessage ) );
    my $usersModel = LetsGoSmoke::Model::Users->new( collection => $self->dbClient->get_collection( 'Users' ) );

    #set 'from' user
    my $from = $usersModel->get(
        username    => $self->request->{from},
        host        => $self->connectionInfo->{host},
        port        => $self->connectionInfo->{port},
    );
    $self->_set_from( $from );

    #set 'to' users
    if ( exists $self->request->{to} and scalar @{ $self->request->{to} } != 0 ) {
        my $to = $usersModel->find( userlist => $self->request->{to} );
        self->_set_to( $to );
    }

    #choose handler
    my %controller_params = (
        from        => $self->from,
        request     => $self->request->{request},
        dbClient    => $self->dbClient,
        usersModel  => $usersModel,
    );
    if ( exists $self->request->{request}->{status} ) {
        $self->_set_controller( LetsGoSmoke::Controller::Status->new( %controller_params ) );
    } elsif ( exists $self->request->{request}->{offer} ) {
        $controller_params{to} = $self->to;
        $self->_set_controller( LetsGoSmoke::Controller::Offer->new( %controller_params ) );
    } elsif ( exists $self->request->{request}->{confirmation} ) {
        $controller_params{to} = $self->to;
        $self->_set_controller( LetsGoSmoke::Controller::Confirmation->new( %controller_params ) );
    }
}

sub clear_temp_vars {
    my $self = shift;

    $self->_clear_from;
    $self->_clear_to;
    $self->_clear_request;
    $self->_clear_requestMessage;
    $self->_clear_connectionInfo;
    $self->_clear_controller;
}

__PACKAGE__->meta->make_immutable;

1;