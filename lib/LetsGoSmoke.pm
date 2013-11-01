package LetsGoSmoke;

use version; our version 0.1.0;

use Moose;

has 'username' => { is => 'rw', isa => 'Int' };
has 'state' => { is => 'rw', isa => 'Int' };
has 'config' => { is => 'rw', isa => 'HashRef' };

sub process {
    my $self = shift;
}

1;