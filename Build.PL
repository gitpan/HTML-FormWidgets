# @(#)$Ident: DZ_Build.PL 2013-08-15 13:04 pjf ;

use strict;
use warnings;

use Module::Build;

sub whimper { print {*STDOUT} $_[ 0 ]."\n"; exit 0 }

my $perl_ver = 5.01;
my $name     = 'HTML-FormWidgets'; $name =~ s{ - }{::}gmx;

$] >= $perl_ver or $ENV{PERL5_CPANPLUS_IS_VERSION}
   or whimper "Minimum required Perl version is ${perl_ver}";

Module::Build->subclass( code => do { local $/; <DATA> } )->new(
  'module_name' => $name,
  'notes'       => { min_perl_version => $perl_ver },
  'build_requires' => {
    'Module::Build' => '0.4004',
    'Test::Requires' => '0.06',
    'version' => '0.88'
  },
  'configure_requires' => {
    'Module::Build' => '0.4004',
    'version' => '0.88'
  },
  'requires' => {
    'Class::Accessor' => '0.34',
    'Class::Load' => '0.18',
    'HTML::Accessors' => 'v0.8.0',
    'PPI' => '1.215',
    'PPI::HTML' => '1.08',
    'Pod::Xhtml' => '1.61',
    'Try::Tiny' => '0.09',
    'parent' => '0.224',
    'perl' => '5.01'
  },

)->create_build_script;

exit 0;

__DATA__

sub _normalize_prereqs { # Dynamic config
   my $self = shift; my $p = $self->SUPER::_normalize_prereqs; return $p;
}
