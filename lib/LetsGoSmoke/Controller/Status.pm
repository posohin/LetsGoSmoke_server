package LetsGoSmoke::Controller::Status;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Controller::Base';

use LetsGoSmoke::Model::Status;

use Data::Dumper;

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
    my @onlines = map { $_->{username} } @{ $status->getOnline() };
    my $to = $self->usersModel->find( usernames => \@onlines );
    warn Dumper $to;
    $self->set_to( $to );

    $self->_set_notification( $self->request );

    return "Ok";
};

__PACKAGE__->meta->make_immutable;

1;