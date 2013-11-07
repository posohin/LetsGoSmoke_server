package LetsGoSmoke;

use version; our $VERSION = version->parse("0.01_00");

use Moose;
use namespace::autoclean;

has 'from' => (
    is          => 'ro',
    isa         => 'Str',
    writer      => 'set_from',
    clearer     => 'clear_from',
);

has 'to' => (
    is          => 'ro',
    isa         => 'ArrayRef',
    writer      => 'set_to',
    clearer     => 'clear_to',
);

has 'state' => (
    is          => 'ro',
    isa         => 'HashRef',
    writer      => 'set_state',
    clearer     => 'clear_state',
);

has 'config' => (
    is          => 'ro',
    isa         => 'HashRef',
    required    => 1,
);

sub process_request {
    my $self = shift;

    if ( exists $self->state->{status} ) {
        status( $self->state->{status} );
    }
    elsif ( exists $self->state->{offer} ) {
        offer( $self->state->{offer} );
    }
    elsif ( exists $self->state->{approve} ) {
        approve( $self->state->{approve} );
    }
    else {
        die "Wrong request";
    }
}

sub status {
    my $self = shift;
}
sub offer {
    my $self = shift;
}
sub approve {
    my $self = shift;
}

sub clear_temp_vars {
    my $self = shift;

    $self->clear_from;
    $self->clear_to;
    $self->clear_state;
}

__PACKAGE__->meta->make_immutable;

1;