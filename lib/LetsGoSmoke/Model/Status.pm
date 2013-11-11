package LetsGoSmoke::Model::Status;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Model::Base';

#new status model
#set user status
#get users with status online

__PACKAGE__->meta->make_immutable;

1;