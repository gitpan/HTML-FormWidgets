package HTML::FormWidgets::RadioGroup;

# @(#)$Id: RadioGroup.pm 184 2009-06-13 22:25:28Z pjf $

use strict;
use warnings;
use parent qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.5.%d', q$Rev: 184 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(columns labels values) );

sub _init {
   my ($self, $args) = @_;

   $self->columns( undef );
   $self->labels(  undef );
   $self->values(  [] );
   return;
}

sub _render {
   my ($self, $args)   = @_;

   $args->{columns}  = $self->columns  if ($self->columns);
   $args->{labels}   = $self->labels   if ($self->labels);
   $args->{onchange} = $self->onchange if ($self->onchange);
   $args->{values}   = $self->values;

   return $self->hacc->radio_group( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
