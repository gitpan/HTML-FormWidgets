# @(#)$Id: Textarea.pm 351 2012-03-28 23:41:55Z pjf $

package HTML::FormWidgets::Textarea;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.12.%d', q$Rev: 351 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

sub render_field {
   my ($self, $args)  = @_;

   $args->{class} .= ($args->{class} ? q( ): q()).($self->class || q(ifield));

   return $self->hacc->textarea( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
