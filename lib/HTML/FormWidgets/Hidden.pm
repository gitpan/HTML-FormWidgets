package HTML::FormWidgets::Hidden;

# @(#)$Id: Hidden.pm 135 2009-02-19 17:51:07Z pjf $

use strict;
use warnings;
use parent qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.3.%d', q$Rev: 135 $ =~ /\d+/gmx );

sub _init {
   my ($self, $args) = @_;

   $self->container( 0 );
   return;
}

sub _render {
   my ($self, $args) = @_;

   delete $args->{id};
   $args->{type}  = q(hidden);
   $args->{value} = delete $args->{default};

   return $self->hacc->input( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:

