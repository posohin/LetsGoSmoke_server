package LetsGoSmoke::Model::Users;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Model::Base';

#new user model
#get users with sort by status
#create new user
#change user

has 'username' => (
    is => 'ro',
    isa => 'Str',
);

__PACKAGE__->meta->make_immutable;

1;