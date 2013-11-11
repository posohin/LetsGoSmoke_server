package LetsGoSmoke;

use version; our $VERSION = version->parse("0.01_00");

use Moose;
use namespace::autoclean;

use LetsGoSmoke::Model::Users
use JSON;

has 'from' => (
    is          => 'ro',
    isa         => 'LetsGoSmoke::Model::Users',
    writer      => '_set_from',
    clearer     => '_clear_from',
);

has 'to' => (
    is          => 'ro',
    isa         => 'ArrayRef[LetsGoSmoke::Model::Users]',
    writer      => '_set_to',
    clearer     => '_clear_to',
);

has 'message' => (
    is          => 'ro',
    isa         => 'Str',
    writer      => 'set_message',
    clearer     => 'clear_message',
);

has 'dbClient' => (
    is          => 'ro',
    isa         => 'MongoDB::MongoClient',
    writer      => '_set_dbClient',
    lazy        => 1,
);

has 'config' => (
    is          => 'ro',
    isa         => 'Config::JSON',
    required    => 1,
    lazy        => 1,
);

has 'controller' => (
    is          => 'ro',
    isa         => 'LetsGoSmoke::BaseController'
    writer      => '_set_controller',
);

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
    $self->clear_message;
}

__PACKAGE__->meta->make_immutable;

1;