# @(#)$Id: Textarea.pm 345 2012-03-03 17:50:47Z pjf $

package HTML::FormWidgets::Textarea;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.10.%d', q$Rev: 345 $ =~ /\d+/gmx );
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
