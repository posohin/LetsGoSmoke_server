package LetsGoSmoke;

use version; our $VERSION = version->parse("0.01_00");

use v5.14;

use Moose;
use namespace::autoclean;

has 'username' => (
    is          => 'ro',
    isa         => 'Str',
    writer      => 'set_username',
    clearer     => 'clear_username',
);

has 'state' => (
    is          => 'ro',
    isa         => 'Int',
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

    given ( $self->config->{states}->{ $self->state } ) {
        $self->available        when /^available$/;
        $self->smoke_request    when /^smoke_request$/;
        $self->smoke_approve    when /^smoke_approve$/;
        $self->smoke_abort      when /^smoke_abort$/;
    }
}

sub available {}
sub smoke_request {}
sub smoke_approve {}
sub smoke_abort {}

sub clear_temp_vars {
    my $self = shift;

    $self->clear_username;
    $self->clear_state;
}

__PACKAGE__->meta->make_immutable;

1;