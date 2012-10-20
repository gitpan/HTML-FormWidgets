# @(#)$Id: Textarea.pm 377 2012-10-20 14:52:32Z pjf $

package HTML::FormWidgets::Textarea;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.15.%d', q$Rev: 377 $ =~ /\d+/gmx );
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
