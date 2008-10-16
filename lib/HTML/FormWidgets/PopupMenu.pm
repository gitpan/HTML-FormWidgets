package HTML::FormWidgets::PopupMenu;

# @(#)$Id: PopupMenu.pm 83 2008-09-24 00:27:50Z pjf $

use strict;
use warnings;
use base q(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.2.%d', q$Rev: 83 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(labels values) );

sub init {
   my ($self, $args) = @_;

   $self->labels( undef );
   $self->values( [] );

   $self->NEXT::init( $args );
   return;
}

sub _render {
   my ($self, $args)   = @_;

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
