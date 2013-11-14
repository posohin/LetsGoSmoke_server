package LetsGoSmoke::Controller::Status;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Controller::Base';

use LetsGoSmoke::Model::Status;

#get request info (from to message) via construct object
#set new status, get model and add
#response to user ok or fail
#send online users notification of new status

override 'processRequest' => sub {
    my $self = shift;

    my $status = LetsGoSmoke::Model::Status->new(
        collection => $self->dbClient->get_collection( 'Status' ),
    );
    $status->set_from( $self->from );
    $status->setStatus(
        username    => $self->from->{username},
        status      => $self->request->{status}
    );
    my @onlines = map { $_->{username} } $status->getOnline();
    my $to = LetsGoSmoke::Model::Users->find( usernames => \@onlines );
    $self->set_to( $to );

    $self->set_notification( message => $self->request->{status}, type => "status" );

    return "Ok";
}

__PACKAGE__->meta->make_immutable;

1;