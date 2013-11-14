package LetsGoSmoke::Model::Users;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Model::Base';

use Params::Validate qw/:all/;

has 'collection' => (
    is => 'ro',
    isa => 'MongoDB::Collection',
    required => 1,
);

sub get {
    my $self = shift;
    my %params = validate( @_, {
        username    => { type => SCALAR },
        host        => { type => SCALAR },
        port        => { type => SCALAR },
    });
    my $user = $self->collection->find_one( { username => $params{username} } );
    if ( !defined $user or ( $params{host} ne $user->{host} or $params{port} != $user->{port} ) ) {
        $self->collection->update(
            { username => $params{username} },
            { '$set' => {
                host => $params{host},
                port => $params{port}
            }},
            { upsert => 1 }
        );
        $user = {
            username    => $params{username},
            host        => $params{host},
            port        => $params{port},
        };
    }

    return $user;
}

sub find {
    my $self = shift;
    my %params = validate(@_, { usernames => { type => ARRAYREF } });

    return $self->collection->find( { username => { '$in' => $params{usernames} } } )->all;
}

__PACKAGE__->meta->make_immutable;

1;