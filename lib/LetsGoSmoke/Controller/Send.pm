package LetsGoSmoke::Controller::Send;

use Moose;
use namespace::autoclean;

has 'from' => (
    is => 'ro',
    isa => 'LetsGoSmoke::Model::Users',
    required => 1,
);

has 'to' => (
    is => 'ro',
    isa => 'ArrayRef[LetsGoSmoke::Model::Users]',
    required => 1,
);

has 'notification' => (
    is => 'ro',
    isa => 'HashRef',
    required => 1,
);

#get destination info
#get message
#compose and send message @to users via socket

__PACKAGE__->meta->make_immutable;

1;