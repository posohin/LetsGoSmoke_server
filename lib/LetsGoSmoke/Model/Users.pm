package LetsGoSmoke::Model::Users;

use Moose;
use MooseX::Params::Validate;
use namespace::autoclean;

extends 'LetsGoSmoke::Model::Base';

sub get {
    my $self = shift;
    my %params = validated_hash(
        \@_,
        username    => { isa => 'Str' },
        host        => { isa => 'Str' },
        port        => { isa => 'Str' }
    );

    my $user = $self->collection->find_one( { username => $params{username} } );
    if ( !defined $user or ( $params{host} ne $user->{host} or $params{port} != $user->{port} ) ) {
        my %updating_params = (
            username    => $params{username},
            host        => $params{host},
            port        => $params{port},
        );
        $self->collection->update(
            { username => $params{username} },
            { '$set' => \%updating_params },
            { upsert => 1 }
        );
        $user = {%$user, %updating_params};
    }

    return $user;
}

sub find {
    my $self = shift;
    my %params = validated_hash(
        \@_,
        userlist => { isa => 'ArrayRef' }
    );

    my @users = $self->collection->find( { username => { '$in' => $params{userlist} } } )->all;

    return \@users;
}

__PACKAGE__->meta->make_immutable;

1;