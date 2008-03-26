package HTML::FormWidgets::Anchor;

# @(#)$Id: Anchor.pm 28 2008-03-26 15:33:59Z pjf $

use strict;
use warnings;
use base qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 28 $ =~ /\d+/gmx );

sub _render {
   my ($me, $ref)  = @_;

   $ref->{class  } = $me->class || q(linkFade);
   $ref->{href   } = $me->href  || q();
   $ref->{onclick} = $me->onclick if ($me->onclick);

   return $me->elem->a( $ref, $me->text || q(link) );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:

