package HTML::FormWidgets::ScrollingList;

# @(#)$Id: ScrollingList.pm 5 2008-02-11 00:30:56Z pjf $

use strict;
use warnings;
use base qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 5 $ =~ /\d+/gmx );

sub _render {
   my ($me, $ref)   = @_;

   $ref->{labels}   = $me->labels   if ($me->labels);
   $ref->{onchange} = $me->onchange if ($me->onchange);
   $ref->{size}     = $me->height;
   $ref->{values}   = $me->values;
   return $me->elem->scrolling_list( $ref );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
