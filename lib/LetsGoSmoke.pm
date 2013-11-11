package LetsGoSmoke;

use version; our $VERSION = version->parse("0.01_00");

use Moose;
use namespace::autoclean;

use JSON;

has 'from' => (
    is          => 'ro',
    isa         => 'HashRef',
    writer      => '_set_from',
    clearer     => '_clear_from',
);

has 'to' => (
    is          => 'ro',
    isa         => 'ArrayRef',
    writer      => '_set_to',
    clearer     => '_clear_to',
);

has 'message' => (
    is          => 'ro',
    isa         => 'Str',
    writer      => 'set_message',
    clearer     => 'clear_message',
);

has 'dbClient' => (
    is          => 'ro',
    isa         => 'MongoDB::MongoClient',
    writer      => '_set_dbClient',
    lazy        => 1,
);

has 'config' => (
    is          => 'ro',
    isa         => 'Config::JSON',
    required    => 1,
    lazy        => 1,
);

has 'controller' => (
    is          => 'ro',
    isa         => 'LetsGoSmoke::BaseControlle'
    writer      => '_set_controller',
);

sub processRequest {
    #clear temp_var
    #parse message
    #send response message
}

sub parseRequestMessage {
    #convert to hashref
    #parse request type
    #set request controller
}

sub _before_build {
    #create MongoDB::MongoClient
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