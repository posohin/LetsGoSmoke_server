package LetsGoSmoke::Controller::Base;

use Moose;
use namespace::autoclean;

use LetsGoSmoke::Controller::Send;

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

has 'request' => (
    is => 'ro',
    isa => 'HashRef',
    required => 1,
);

has 'notification' => (
    is => 'ro',
    isa => 'HashRef',
    writer => '_set_notification',
);

has 'model' => (
    is => 'ro',
    isa => 'LetsGoSmoke::Model',
    required => 1,
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

    $self->set_notification( $self->model->getNotification() );

    return $self->model->set( request => $self->request ) ? 1 : 0;
}

after 'processRequest' => sub {
    my $self = shift;

    my $sender = LetsGoSmoke::Controller::Send->new(
        from => $self->from,
        to => $self->to,
        notification => $self->notification
    );
    $sender->sendNotifications();
}

__PACKAGE__->meta->make_immutable;

1;