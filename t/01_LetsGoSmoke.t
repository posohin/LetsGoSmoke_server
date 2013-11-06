#!/usr/bin/perl

use warnings;
use strict;

use Test::More qw( no_plan );
use Test::Moose;

use LetsGoSmoke;
use Config::JSON;
use Data::Dumper;

my $config = Config::JSON->new('t/LetsGoSmoke.conf');

### Check class LetsGoSmoke
meta_ok( 'LetsGoSmoke', 'Meta of LetsGoSmoke class is ok' );
has_attribute_ok( 'LetsGoSmoke', 'states', 'LetsGoSmoke has attribute "states"' );
has_attribute_ok( 'LetsGoSmoke', 'username', 'LetsGoSmoke has attribute "username"' );
has_attribute_ok( 'LetsGoSmoke', 'state', 'LetsGoSmoke has attribute "state"' );

### Check attributes and attribute methods
# Create a new object
my $smoking = LetsGoSmoke->new( states => $config->get('states') );

# Check setters, getters and clear temporary attributes method
ok( $smoking->set_state(1), "Setting state" );
is( $smoking->state, 1, "Atrribute state successfully setted" );
ok( $smoking->set_username('smoker'), "Setting username" );
is( $smoking->username, 'smoker', "Atrribute username successfully setted" );
ok( $smoking->clear_temporary, 'Clearing temporary attributes' );
is( $smoking->state, undef, 'State successfully cleared' );
is( $smoking->username, undef, 'Username successfully cleared' );