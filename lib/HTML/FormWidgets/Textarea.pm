# @(#)$Id: Textarea.pm 255 2010-06-24 23:41:32Z pjf $

package HTML::FormWidgets::Textarea;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.6.%d', q$Rev: 255 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(height width wrap) );

sub init {
   my ($self, $args) = @_;

   $self->height( 5  );
   $self->width ( 60 );
   $self->wrap  ( q(soft) );
   return;
}

sub render_field {
   my ($self, $args)  = @_;

   $args->{class} .= q( ifield).($self->class ? q( ).$self->class : q());
   $args->{cols }  = $self->width;
   $args->{rows }  = $self->height;
   $args->{wrap }  = $self->wrap;

   return $self->hacc->textarea( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
