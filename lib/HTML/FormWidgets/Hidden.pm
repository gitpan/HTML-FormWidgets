# @(#)$Id: Hidden.pm 345 2012-03-03 17:50:47Z pjf $

package HTML::FormWidgets::Hidden;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.10.%d', q$Rev: 345 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

sub init {
   my ($self, $args) = @_;

   $self->container( 0 );
   return;
}

sub render_field {
   my ($self, $args) = @_;

   delete $args->{id};
   $args->{type}  = q(hidden);
   $args->{value} = delete $args->{default} || q();

   return $self->hacc->input( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:

