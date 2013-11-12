package LetsGoSmoke::Controller::Offer;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Controller::Base';

#get request info (from to message) via construct object
#create or abort offer
#response to user ok or fail
#send @to users notification of offer

__PACKAGE__->meta->make_immutable;

1;