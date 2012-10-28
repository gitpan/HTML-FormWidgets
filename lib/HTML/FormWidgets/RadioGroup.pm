# @(#)$Id: RadioGroup.pm 382 2012-10-28 23:52:22Z pjf $

package HTML::FormWidgets::RadioGroup;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.16.%d', q$Rev: 382 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(columns labels values) );

sub init {
   my ($self, $args) = @_;

   $self->columns( undef );
   $self->labels ( undef );
   $self->values ( [] );
   return;
}

sub render_field {
   my ($self, $args) = @_; my $hacc = $self->hacc;

   $args->{label_class} = q(radio_group);
   $args->{columns    } = $self->columns  if ($self->columns);
   $args->{labels     } = $self->labels   if ($self->labels);
   $args->{onchange   } = $self->onchange if ($self->onchange);
   $args->{values     } = $self->values;

   my $html = $hacc->radio_group( $args );

   return $hacc->div( { class => q(checkbox_container) }, $html );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
