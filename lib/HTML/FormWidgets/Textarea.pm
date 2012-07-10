# @(#)$Id: Textarea.pm 368 2012-07-09 23:45:58Z pjf $

package HTML::FormWidgets::Textarea;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.14.%d', q$Rev: 368 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(cols rows) );

sub init {
   my ($self, $args) = @_;

   $self->cols( 60 );
   $self->rows( 1  );
   return;
}

sub render_field {
   my ($self, $args)  = @_;

   $args->{class} .= ($args->{class} ? q( ): q()).($self->class || q(ifield));

   $args->{cols }  = $self->cols; $args->{rows} = $self->rows;

   return $self->hacc->textarea( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
