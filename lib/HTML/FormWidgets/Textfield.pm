# @(#)$Id: Textfield.pm 312 2011-06-26 19:36:57Z pjf $

package HTML::FormWidgets::Textfield;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.7.%d', q$Rev: 312 $ =~ /\d+/gmx );
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
