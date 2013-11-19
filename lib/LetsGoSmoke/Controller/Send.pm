package LetsGoSmoke::Controller::Send;

use Moose;
use namespace::autoclean;

use JSON;
use IO::Socket::INET;
use Data::Dumper;

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

sub sendNotification {
    my $self = shift;

    my $message = $self->composeMessage();
    foreach my $user ( @{ $self->to } ) {
        my $socket = new IO::Socket::INET (
            PeerHost => $user->{host},
            PeerPort => $user->{port},
            Proto => 'tcp',
        ) or warn("ERROR in Socket Creation : $!\n"), next;
        $socket->send( $message );
        $socket->close();
    }
}

sub composeMessage {
    my $self = shift;

    my $data = {
        from    => $self->from->{username},
        request => $self->notification
    };
    my $message = to_json($data);

    return $message;
}

__PACKAGE__->meta->make_immutable;

1;