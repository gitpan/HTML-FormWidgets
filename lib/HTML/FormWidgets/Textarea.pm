package HTML::FormWidgets::Textarea;

# @(#)$Id: Textarea.pm 184 2009-06-13 22:25:28Z pjf $

use strict;
use warnings;
use parent qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.5.%d', q$Rev: 184 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(height width) );

sub _init {
   my ($self, $args) = @_;

   $self->height( 5 );
   $self->width(  60 );
   return;
}

sub _render {
   my ($self, $args)  = @_;

   $args->{cols} = $self->width;
   $args->{rows} = $self->height;

   return $self->hacc->textarea( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
