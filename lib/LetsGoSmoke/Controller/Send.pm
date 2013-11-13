package LetsGoSmoke::Controller::Send;

use Moose;
use namespace::autoclean;

use JSON;
use IO::Socket::INET;

has 'from' => (
    is => 'ro',
    isa => 'HashRef',
    required => 1,
);

has 'to' => (
    is => 'ro',
    isa => 'ArrayRef[HashRef]',
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
sub sendNotification {
    my $self = shift;

    my $message = $self->composeMessage();
    foreach my $user ( @{ $self->to } ) {
        my $socket = new IO::Socket::INET (
            PeerHost => $user->{host},
            PeerPort => $user->{port},
            Proto => 'tcp',
        ) or die "ERROR in Socket Creation : $!\n";
    }
}

sub composeMessage {
    my $self = shift;
}

__PACKAGE__->meta->make_immutable;

1;