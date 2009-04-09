package HTML::FormWidgets::Textfield;

# @(#)$Id: Textfield.pm 154 2009-04-09 17:04:48Z pjf $

use strict;
use warnings;
use parent qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.4.%d', q$Rev: 154 $ =~ /\d+/gmx );

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
