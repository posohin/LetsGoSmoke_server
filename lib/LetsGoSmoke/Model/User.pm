package LetsGoSmoke::Model::User;

use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

use MongoDB;

enum 'status', [ qw( 0 1 ) ];

has 'username' => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has 'status' => (
    is => 'ro',
    isa => 'status',
    default => '0',
    writer => 'set_status',
);

has 'hostPort' => (
    is => 'ro',
    isa => subtype( 'Str' => where { $_ =~ /^(\d{1,3}\.){3}\d{1,3}\:\d+$/ } ),
    writer => 'set_hostPort',
);

has 'config' => (
    is => 'ro',
    isa => 'Config::JSON',
    predicate => 'has_config',
    required => 1,
);

has 'client' => (
    is => 'ro',
    isa => 'MongoDB::MongoClient',
    init_arg => 'config',
    builder => '_build_client',
    predicate => 'has_client',
);

sub _build_client {
    my $self = shift;

    return MongoDB::MongoClient->new(
        host => $self->config->get('mongodb/host'),
        port => $self->get('mongodb/port'),
    );
}
