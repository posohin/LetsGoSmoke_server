package LetsGoSmoke::Model::Confirmation;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Model::Base';

#new confirmation model
#set confirmation status
#get confiramtion status
#get users with same offer

__PACKAGE__->meta->make_immutable;

1;