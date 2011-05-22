# @(#)$Id: Textfield.pm 279 2010-08-29 00:17:46Z pjf $

package HTML::FormWidgets::Textfield;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.6.%d', q$Rev: 279 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(width) );

sub init {
   my ($self, $args) = @_;

   $self->width( 40 );
   return;
}

sub render_field {
   my ($self, $args) = @_;

   $args->{class} .= q( ).($self->class || q(ifield));
   $args->{size }  = $self->width;

   return $self->hacc->textfield( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
