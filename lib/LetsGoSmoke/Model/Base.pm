package LetsGoSmoke::Model::Base;

use Moose;
use namespace::autoclean;

has 'collection' => (
    is          => 'ro',
    isa         => 'MongoDB::Collection',
    required    => 1,
);

has 'from' => (
    is          => 'ro',
    isa         => 'HashRef',
    writer      => 'set_from',
);

has 'to' => (
    is          => 'ro',
    isa         => 'HashRef',
    writer      => 'set_to',
);

__PACKAGE__->meta->make_immutable;

1;