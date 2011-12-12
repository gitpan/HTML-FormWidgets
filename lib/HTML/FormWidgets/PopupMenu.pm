# @(#)$Id: PopupMenu.pm 334 2011-12-12 04:30:18Z pjf $

package HTML::FormWidgets::PopupMenu;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.8.%d', q$Rev: 334 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(labels values) );

sub init {
   my ($self, $args) = @_;

   $self->labels( undef );
   $self->values( [] );
   return;
}

sub render_field {
   my ($self, $args)   = @_;

   $self->class =~ m{ chzn-select }msx
      and $self->add_optional_js( q(chosen.js) );

   $args->{class} .= q( ).($self->class || q(ifield));
   $self->onchange and $args->{onchange} = $self->onchange;

   if ($self->labels) {
      my $labels = $args->{labels} = $self->labels;

      $args->{values} = [ sort {
         ($labels->{ $a } || q()) cmp ($labels->{ $b } || q()) }
                          @{ $self->values } ];
   }
   else { $args->{values} = $self->values }

   return $self->hacc->popup_menu( $args );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
