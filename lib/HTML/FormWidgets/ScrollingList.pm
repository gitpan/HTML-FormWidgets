package HTML::FormWidgets::ScrollingList;

# @(#)$Id: ScrollingList.pm 135 2009-02-19 17:51:07Z pjf $

use strict;
use warnings;
use parent qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.3.%d', q$Rev: 135 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(height labels values) );

sub _init {
   my ($self, $args) = @_;

   $self->height( 10 );
   $self->labels( undef );
   $self->values( [] );
   return;
}

sub _render {
   my ($self, $args) = @_;

   $args->{labels}   = $self->labels   if ($self->labels);
   $args->{onchange} = $self->onchange if ($self->onchange);
   $args->{size}     = $self->height;
   $args->{values}   = $self->values;

   return $self->hacc->scrolling_list( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
