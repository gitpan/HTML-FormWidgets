package HTML::FormWidgets::Textfield;

# @(#)$Id: Textfield.pm 7 2008-02-18 00:45:41Z pjf $

use strict;
use warnings;
use base qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 7 $ =~ /\d+/gmx );

sub _render {
   my ($me, $ref) = @_;

   $ref->{size} = $me->width || 60;

   return $me->elem->textfield( $ref );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
