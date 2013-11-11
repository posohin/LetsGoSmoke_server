package LetsGoSmoke::Controller::Base;

use Moose;
use namespace::autoclean;

has 'from' => (
    is => 'ro',
    isa => 'LetsGoSmoke::Model::Users',
);

has 'to' => (
    is => 'ro',
    isa => 'ArrayRef[LetsGoSmoke::Model::Users]',
);

has 'requestMessage' => (
    is => 'ro',
    isa => 'HashRef',
);

has 'model' => (
    is => 'ro',
    isa => 'LetsGoSmoke::Model::Base',
);

sub processRequest {
    my $self = shift;
}

sub send_messages {
    my $self = shift;
}

__PACKAGE__->meta->make_immutable;

1;