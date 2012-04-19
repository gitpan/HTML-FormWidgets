# @(#)$Id: Hidden.pm 358 2012-04-19 15:20:34Z pjf $

package HTML::FormWidgets::Hidden;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.13.%d', q$Rev: 358 $ =~ /\d+/gmx );
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

