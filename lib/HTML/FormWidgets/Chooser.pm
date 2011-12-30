# @(#)$Id: Chooser.pm 335 2011-12-29 23:59:43Z pjf $

package HTML::FormWidgets::Chooser;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.9.%d', q$Rev: 335 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(config field href) );

sub init {
   my ($self, $args) = @_;

   $self->class  ( q(chooser_button fade) );
   $self->config ( { height   => 500, screen_x => 10,
                     screen_y => 10,  width    => 500 } );
   $self->default( q(Choose) );
   $self->field  ( q() );
   $self->href   ( undef );
   return;
}

sub render_field {
   my $self = shift;

   $self->config->{field} = '"'.$self->field.'"';
   $self->config->{href } = '"'.$self->href.'"';
   $self->add_literal_js( 'anchors', $self->id, $self->config );

   return $self->hacc->submit( { class => $self->class,
                                 id    => $self->id,
                                 name  => q(_method),
                                 value => $self->default } );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
