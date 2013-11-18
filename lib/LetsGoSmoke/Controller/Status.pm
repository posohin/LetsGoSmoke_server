package LetsGoSmoke::Controller::Status;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Controller::Base';

use LetsGoSmoke::Model::Status;

override 'processRequest' => sub {
    my $self = shift;

    #new status model
    my $status = LetsGoSmoke::Model::Status->new(
        collection => $self->dbClient->get_collection( 'Status' ),
    );
    #set 'from' user
    $status->set_from( $self->from );
    #set new status to 'from' user
    my $error = $status->setStatus(
        status  => $self->request->{status}
    );

    unless ( defined $error ) {
        #get online users list
        my $onlines =  $status->getOnline();
        #get online users models
        my $to = $self->usersModel->find( userlist => $onlines );
        #set to controller 'to' users
        $self->set_to( $to );

        #set notification
        $self->_set_notification( $self->request );

        return "Status successfully updated";
    } else {
        return "Updating status is failed";
    }
};

__PACKAGE__->meta->make_immutable;

1;