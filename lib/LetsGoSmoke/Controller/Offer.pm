package LetsGoSmoke::Controller::Offer;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Controller::Base';

#get request info (from to message)
#create new offer
#response to user ok or fail
#send offer to users from 'from'

__PACKAGE__->meta->make_immutable;

1;