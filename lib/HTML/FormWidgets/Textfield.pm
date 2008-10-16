package HTML::FormWidgets::Textfield;

# @(#)$Id: Textfield.pm 83 2008-09-24 00:27:50Z pjf $

use strict;
use warnings;
use base qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.2.%d', q$Rev: 83 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(width) );

sub init {
   my ($self, $args) = @_;

   $self->width( 40 );

   $self->NEXT::init( $args );
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
