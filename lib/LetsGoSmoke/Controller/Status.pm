package LetsGoSmoke::Controller::Status;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Controller::Base';

#get request info (from to message)
#set new status
#response to user ok or fail
#send other users new status of requesting user

__PACKAGE__->meta->make_immutable;

1;