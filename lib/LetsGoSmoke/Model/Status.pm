package LetsGoSmoke::Model::Status;

use Moose;
use MooseX::Params::Validate;
use namespace::autoclean;

extends 'LetsGoSmoke::Model::Base';

sub getOnlines {
    my $self = shift;

    my @onlines = map { $_->{username} ne $self->from->{username} ? $_->{username} : () } $self->collection->find( { status => 1 } )->all;

    return \@onlines;
}

sub setStatus {
    my $self = shift;
    my %params = validated_hash(
        \@_,
        status  => { isa => 'Str' }
    );

    my $status = undef;
    if ( $params{status} =~ /^Hello,\s+world!$/ ) {
        $status = 1;
    } elsif ( $params{status} =~ /^Good\s+bye$/ ) {
        $status = 0;
    }

    if ( defined $status ) {
        $self->collection->update(
            { username => $self->from->{username} },
            { '$set' => { status => $status } },
            { upsert => 1 }
        );
        my $onlines = $self->getOnlines();

        return $onlines;
    }
}

__PACKAGE__->meta->make_immutable;

1;