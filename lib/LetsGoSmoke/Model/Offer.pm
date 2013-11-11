package LetsGoSmoke::Model::Offer;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Model::Base';

#new offer model
#set status or create new offer (with create confirmations)
#get offer status
#get list of offer's users

__PACKAGE__->meta->make_immutable;

1;