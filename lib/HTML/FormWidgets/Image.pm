package HTML::FormWidgets::Image;

# @(#)$Id: Image.pm 184 2009-06-13 22:25:28Z pjf $

use strict;
use warnings;
use parent qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.5.%d', q$Rev: 184 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(fhelp) );

sub _init {
   my ($self, $args) = @_;

   $self->fhelp(   q() );
   $self->tiptype( q(normal) );
   return;
}

sub _render {
   my ($self, $args) = @_;

   return $self->hacc->img( { alt   => $self->fhelp,
                              class => $self->class,
                              src   => $self->text } );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
