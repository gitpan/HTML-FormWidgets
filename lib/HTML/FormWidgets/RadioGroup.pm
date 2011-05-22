# @(#)$Id: RadioGroup.pm 224 2010-02-12 18:44:46Z pjf $

package HTML::FormWidgets::RadioGroup;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.6.%d', q$Rev: 224 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(columns labels values) );

sub init {
   my ($self, $args) = @_;

   $self->columns( undef );
   $self->labels(  undef );
   $self->values(  [] );
   return;
}

sub render_field {
   my ($self, $args)   = @_;

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
