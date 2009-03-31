package HTML::FormWidgets::Textfield;

# @(#)$Id: Textfield.pm 135 2009-02-19 17:51:07Z pjf $

use strict;
use warnings;
use parent qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.3.%d', q$Rev: 135 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(width) );

sub _init {
   my ($self, $args) = @_;

   $self->width( 40 );
   return;
}

sub _render {
   my ($self, $args) = @_;

   $args->{size} = $self->width;

   return $self->hacc->textfield( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
