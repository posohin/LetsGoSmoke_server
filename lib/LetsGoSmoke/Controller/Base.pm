package LetsGoSmoke::Controller::Base;

use Moose;
use namespace::autoclean;

use LetsGoSmoke::Controller::Send;

has 'from' => (
    is          => 'ro',
    isa         => 'HashRef',
    required    => 1,
);

has 'to' => (
    is          => 'ro',
    isa         => 'ArrayRef[HashRef]',
    writer      => 'set_to',
);

has 'request' => (
    is          => 'ro',
    isa         => 'HashRef',
    required    => 1,
);

has 'dbClient' => (
    is          => 'ro',
    isa         => 'MongoDB::Database',
    required    => 1,
);

has 'usersModel' => (
    is          => 'ro',
    isa         => 'LetsGoSmoke::Model::Users',
    required    => 1,
);

sub processRequest {
    my $self = shift;

    return 'Ok, query type you requested does not exist.';
}


__PACKAGE__->meta->make_immutable;

1;