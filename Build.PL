use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
    module_name     => 'LetsGoSmoke',
    dist_author     => 'Nikita Posokhin (n.posohin@adriver.ru)',
    dist_abstract   => 'Server side of a LetsGoSmoke app',
    license         => 'gpl',
    requires        => {
        'perl'                      => '5.14.2',
        'Moose'                     => '2.1005',
        'Getopt::Long::Descriptive' => '0.096',
        'IO::Socket::INET'          => '1.31',
        'Config::JSON'              => '1.5100',
        'JSON'                      => '2.90',
        'namespace::autoclean'      => '0.14',
        'MongoDB::MongoClient'      => '0.702.2',
        'MooseX::Params::Validate'  => 0,
    },
    requires_build  => {
        'Module::Build' => '0.3800',
        'Data::Dumper'  => 0,
        'Test::More'    => 0,
        'Test::Moose'   => 0,
    },
    install_base    => '/usr/local/LetsGoSmoke/',
);

$build->create_build_script();