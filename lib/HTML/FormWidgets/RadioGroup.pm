# @(#)$Id: RadioGroup.pm 335 2011-12-29 23:59:43Z pjf $

package HTML::FormWidgets::RadioGroup;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.9.%d', q$Rev: 335 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(columns labels values) );

sub init {
   my ($self, $args) = @_;

   $self->columns        ( undef );
   $self->container_class( q(checkbox_container) );
   $self->labels         ( undef );
   $self->values         ( [] );
   return;
}

sub render_field {
   my ($self, $args) = @_;

   $args->{label_class} = q(radio_group);
   $args->{columns    } = $self->columns  if ($self->columns);
   $args->{labels     } = $self->labels   if ($self->labels);
   $args->{onchange   } = $self->onchange if ($self->onchange);
   $args->{values     } = $self->values;

   return $self->hacc->radio_group( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
