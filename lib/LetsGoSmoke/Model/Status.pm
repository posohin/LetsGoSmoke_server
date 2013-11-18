package LetsGoSmoke::Model::Status;

use Moose;
use MooseX::Params::Validate;
use namespace::autoclean;

extends 'LetsGoSmoke::Model::Base';

sub getOnline {
    my $self = shift;

    my @onlines = map { $_->{username} } $self->collection->find( { status => "1" } )->all;

    return \@onlines;
}

sub setStatus {
    my $self = shift;
    my %params = validated_hash(
        \@_,
        status  => { isa => 'Str' }
    );

    $self->collection->update(
        { username => $self->from->{username} },
        { '$set' => { status => $params{status} } },
        { upsert => 1 }
    );

    return "Ok";
}

__PACKAGE__->meta->make_immutable;

1;