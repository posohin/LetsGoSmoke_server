package LetsGoSmoke::Model::Status;

use Moose;
use namespace::autoclean;

extends 'LetsGoSmoke::Model::Base';

use Params::Validate qw(:all);
use Data::Dumper;

sub getOnline {
    my $self = shift;

    my @onlines = $self->collection->find( { status => "1" } )->fields( { username => 1, _id => 0 } )->all;
    warn Dumper \@onlines;

    return \@onlines;
}

sub setStatus {
    my $self = shift;
    my %params = validate(@_, {
        username    => { type => SCALAR },
        status      => { type => SCALAR }
    });

    $self->collection->update(
        { username => $params{username} },
        { '$set' => { status => $params{status} } },
        { upsert => 1 }
    );

    return "Ok";
}
#new status model
#set user status
#get users with status online

__PACKAGE__->meta->make_immutable;

1;