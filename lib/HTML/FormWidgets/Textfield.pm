package HTML::FormWidgets::Textfield;

# @(#)$Id: Textfield.pm 68 2008-07-24 16:26:33Z pjf $

use strict;
use warnings;
use base qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 68 $ =~ /\d+/gmx );

sub _render {
   my ($me, $ref) = @_;

   $ref->{size} = $me->width || 40;

   return $me->elem->textfield( $ref );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
