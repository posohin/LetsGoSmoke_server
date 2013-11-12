package LetsGoSmoke::Controller::Status;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Controller::Base';

#get request info (from to message) via construct object
#set new status, get model and add
#response to user ok or fail
#send online users notification of new status

__PACKAGE__->meta->make_immutable;

1;