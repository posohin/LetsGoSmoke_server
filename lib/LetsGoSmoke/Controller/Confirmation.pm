package LetsGoSmoke::Controller::Confirmation;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Controller::Base';

#get request info (from to message)
#set confirmation status
#response user ok or fail
#send offer's users new confirmation status

__PACKAGE__->meta->make_immutable;

1;