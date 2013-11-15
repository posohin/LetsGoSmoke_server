package LetsGoSmoke::Controller::Confirmation;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Controller::Base';

#get request info (from to message) via construct object
#set confirmation status
#response user ok or fail
#send @to users notification of confirmation status

override 'processRequest' => sub {
    my $self = shift;

    #
};

__PACKAGE__->meta->make_immutable;

1;