# @(#)$Id: Image.pm 312 2011-06-26 19:36:57Z pjf $

package HTML::FormWidgets::Image;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.7.%d', q$Rev: 312 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(fhelp) );

sub init {
   my ($self, $args) = @_;

   $self->fhelp(   q() );
   $self->tiptype( q(normal) );
   return;
}

sub render_field {
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
