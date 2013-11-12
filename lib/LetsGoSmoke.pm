package LetsGoSmoke;

use version; our $VERSION = version->parse("0.01_00");

use Moose;
use namespace::autoclean;

use LetsGoSmoke::Model::Users;
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

has 'model' => (
    is          => 'ro',
    isa         => 'LetsGoSmoke::Model::Base',
    writer      => '_set_model',
    clearer     => '_clear_model',
);

#set requestMessage, connectionInfo
#processRequest {
#parse requestMessage
#process request by controller
#get response
#}
#parse requestMessage{
# get userModel (userModel creates or check user)
# choose controller
#}


sub parseRequestMessage {
    my $self = shift;

    my $request = from_json( $self->requestMessage );
    my $userModel = LetsGoSmoke::Model::Users->new( dbClient => $self->dbClient );
    my $from = userModel->find(
        username => $request->{from},
        host => $self->connectionInfo->{host},
        port => $self->connectionInfo->{port},
    );
    $self->set_from( $from );
    if ( defined $request->{to} and ref $request->{to} eq "ARRAY" ) {
        my @to = ();
        foreach my $username ( @{ $request->{to} } ) {
            my $userModel = userModel->get( username => $username );
            push @to, $userModel if defined userModel;
        }
        self->set_to( \@to );
    } elsif ( defined $request->{to} and ref $request->{to} eq "SCALAR" ) {
        my $to = userModel->get( username => $username );
        $self->set_to( [$to] );
    }
#choose controller
}

sub processRequest {
    #return response message
}

sub _before_build {
    #create MongoDB::MongoClient
}

sub set_message {
    my $self = shift;

    $self->clear_temp_vars;
    #parse request message, set attributes from, to
    #set request type
}

sub clear_temp_vars {
    my $self = shift;

    $self->clear_from;
    $self->clear_to;
    $self->clear_requestMessage;
    $self->clear_connectionInfo;
    $self->clear_controller;
    $self->clear_model;
}

__PACKAGE__->meta->make_immutable;

1;