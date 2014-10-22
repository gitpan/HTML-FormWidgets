# @(#)$Id: CPANTesting.pm 350 2012-03-28 10:47:43Z pjf $

package CPANTesting;

use strict;
use warnings;

my $uname = qx(uname -a);

sub broken {
   $uname     =~ m{ bandsman       }mx and return 'Stopped Horne';
   $uname     =~ m{ higgsboson     }mx and return 'Stopped dcollins';
   $uname     =~ m{ profvince.com  }mx and return 'Stopped vpit';
   $ENV{PATH} =~ m{ \A /home/sand  }mx and return 'Stopped Konig';
   return 0;
}

1;

__END__
