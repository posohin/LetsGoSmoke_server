package LetsGoSmoke::Controller::Status;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Controller::Base';

use LetsGoSmoke::Model::Status;
use Data::Dumper;

override 'processRequest' => sub {
    my $self = shift;

    #new status model
    my $status = LetsGoSmoke::Model::Status->new(
        collection  => $self->dbClient->get_collection( 'Status' ),
        from        => $self->from,
    );
    #set new status to 'from' user
    my $onlines = $status->setStatus(
        status => $self->request->{status}
    );

    if ( defined $onlines and scalar @$onlines != 0 ) {
        #get online users models
        my $to = $self->usersModel->find( userlist => $onlines );
        #set to controller 'to' users
        $self->set_to( $to );

        my $sender = LetsGoSmoke::Controller::Send->new(
            from            => $self->from,
            to              => $self->to,
            notification    => $self->request,
        );
        $sender->sendNotification();

        return $onlines;
    } else {
        return "Updating status is failed";
    }
};

__PACKAGE__->meta->make_immutable;

1;