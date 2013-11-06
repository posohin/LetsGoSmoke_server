package LetsGoSmoke;

use version; our $VERSION = version->parse("0.01_00");

use Moose;
use namespace::autoclean;

has 'username' => (
    is          => 'ro',
    isa         => 'Str',
    writer      => 'set_username',
);
has 'state' => (
    is          => 'ro',
    isa         => 'Int',
    writer      => 'set_state',
);
has 'states' => (
    is          => 'rw',
    isa         => 'HashRef',
    required    => 1,
);

sub process {
    my $self = shift;
}

__PACKAGE__->meta->make_immutable;

1;