#!/usr/bin/perl

use warnings;
use strict;

use Test::More qw( no_plan );
use Test::Moose;

use LetsGoSmoke;
use Config::JSON;
use Data::Dumper;

my $config = Config::JSON->new('t/LetsGoSmoke.conf');

meta_ok( 'LetsGoSmoke', 'Meta of LetsGoSmoke class is ok' );
has_attribute_ok( 'LetsGoSmoke', 'states', 'LetsGoSmoke has attribute "states"' );
has_attribute_ok( 'LetsGoSmoke', 'username', 'LetsGoSmoke has attribute "username"' );
has_attribute_ok( 'LetsGoSmoke', 'state', 'LetsGoSmoke has attribute "state"' );

my $smoking = LetsGoSmoke->new( states => $config->get('states') );
ok( $smoking->set_state(1), "Setting state" );
is( $smoking->state, 1, "Atrribute state successefuly setted" );
ok( $smoking->set_username('smoker'), "Setting username" );
is( $smoking->username, 'smoker', "Atrribute username successefuly setted" );