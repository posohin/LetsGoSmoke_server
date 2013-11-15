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

has 'controller' => (
    is          => 'ro',
    isa         => 'LetsGoSmoke::Controller'
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
    my $usersModel = LetsGoSmoke::Model::Users->new( collection => $self->dbClient->get_collection( 'Users' ) );

    #set 'from' user
    my $from = $usersModel->get(
        username    => $request->{from},
        host        => $self->connectionInfo->{host},
        port        => $self->connectionInfo->{port},
    ); #get new or exists user hashref
    $self->set_from( $from );

    #set 'to' users
    if ( exists $request->{to} and scalar @{ $request->{to} } != 0 ) {
        my $to = $usersModel->find( usernames => $request->{to} );
        self->set_to( $to );
    }

    #choose handler
    my %controller_params = (
        from        => $self->from,
        to          => $self->to,
        request     => $request->{request},
        dbClient    => $self->dbClient,
        usersModel  => $usersModel,
    );
    if ( exists $request->{request}->{status} ) {
        $self->set_controller( LetsGoSmoke::Controller::Status->new( %controller_params ) );
    } elsif ( exists $request->{request}->{offer} ) {
        $self->set_controller( LetsGoSmoke::Controller::Offer->new( %controller_params ) );
    } elsif ( exists $request->{request}->{confirmation} ) {
        $self->set_controller( LetsGoSmoke::Controller::Confirmation->new( %controller_params ) );
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