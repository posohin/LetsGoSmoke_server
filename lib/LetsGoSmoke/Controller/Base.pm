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
    required    => 1,
);

has 'request' => (
    is          => 'ro',
    isa         => 'HashRef',
    required    => 1,
);

has 'dbClient' => (
    is          => 'ro',
    isa         => 'MongoDB::MongoClient',
    required    => 1,
);

has 'notification' => (
    is          => 'ro',
    isa         => 'HashRef',
    writer      => '_set_notification',
);

#process request {
#set to db new state
#return response to user
#}
#after process request {
#send notification to users
#}

sub processRequest {
    my $self = shift;

    $self->set_notification( undef );

    return 'Ok, query type you requested, does not exist.';
}

after 'processRequest' => sub {
    my $self = shift;

    my $sender = LetsGoSmoke::Controller::Send->new(
        from => $self->from,
        to => $self->to,
        notification => $self->notification,
    );
    $sender->sendNotification();
}

__PACKAGE__->meta->make_immutable;

1;