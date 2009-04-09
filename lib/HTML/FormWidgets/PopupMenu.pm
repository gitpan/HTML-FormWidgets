package HTML::FormWidgets::PopupMenu;

# @(#)$Id: PopupMenu.pm 154 2009-04-09 17:04:48Z pjf $

use strict;
use warnings;
use parent q(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.4.%d', q$Rev: 154 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(labels values) );

sub _init {
   my ($self, $args) = @_;

   $self->labels( undef );
   $self->values( [] );
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
