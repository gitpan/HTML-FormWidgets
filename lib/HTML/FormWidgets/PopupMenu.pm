# @(#)$Id: PopupMenu.pm 312 2011-06-26 19:36:57Z pjf $

package HTML::FormWidgets::PopupMenu;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.7.%d', q$Rev: 312 $ =~ /\d+/gmx );
use parent q(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(labels values) );

sub init {
   my ($self, $args) = @_;

   $self->labels( undef );
   $self->values( [] );
   return;
}

sub render_field {
   my ($self, $args)   = @_;

   $args->{class }  .= q( ifield);
   $args->{labels}   = $self->labels   if ($self->labels);
   $args->{onchange} = $self->onchange if ($self->onchange);
   $args->{values}   = $self->values;

   return $self->hacc->popup_menu( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
