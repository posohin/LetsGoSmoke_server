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

has 'request' => (
    is          => 'ro',
    isa         => 'HashRef',
    writer      => 'set_request',
    clearer     => 'clear_request',
);

has 'config' => (
    is          => 'ro',
    isa         => 'Config::JSON',
    required    => 1,
);

has 'hostPort' => {
    is          => 'ro',
    isa         => subtype( 'Str' => where { $_ =~ /^(\d{1,3}\.){3}\d{1,3}\:\d+$/ } ),
    writer      => 'set_hostPort',
    clearer     => 'clear_hostPort',
}

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
    $self->clear_request;
    $self->clear_hostPort
}

__PACKAGE__->meta->make_immutable;

1;