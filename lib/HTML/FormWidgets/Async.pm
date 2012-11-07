# @(#)$Id: Async.pm 384 2012-10-31 01:21:58Z pjf $

package HTML::FormWidgets::Async;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.17.%d', q$Rev: 384 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(config) );

sub init {
   my ($self, $args) = @_;

   $self->class( q(server) );
   $self->config( [] );
   $self->container( 0 );
   $self->sep( q() );
   return;
}

sub render_field {
   my ($self, $args) = @_; my $hacc = $self->hacc;

   for my $item (@{ $self->config }) {
      while (my ($id, $js) = each %{ $item }) {
         $self->add_literal_js( q(server), $id, $js );
      }
   }

   return $hacc->div( { class => $self->class, id => $self->id }, $self->text );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
