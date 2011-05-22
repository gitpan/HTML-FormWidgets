# @(#)$Id: ScrollPin.pm 280 2010-09-04 22:24:26Z pjf $

package HTML::FormWidgets::ScrollPin;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.6.%d', q$Rev: 280 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(config) );

my $TTS = q( ~ );

sub init {
   my ($self, $args) = @_;

   my $prefix  = $self->loc( 'Scroll to' ).$TTS;
   my $default = $self->loc( 'an anchor on the page' );

   $self->class( q(pintray) );
   $self->config( {
      pins   => "{ '.pintarget': { icon: 'scrollpin_icon tips' } }",
      title  => "function( el ) {
         var id = \$( el.id + '_label' );
         return '${prefix}' + (id ? id.textContent : '${default}'); }",
      target => "'content'" } );
   $self->container( 0 );
   return;
}

sub render_field {
   my ($self, $args) = @_;

   $self->_js_config( 'scrollPins', $self->id, $self->config );

   return $self->hacc->ul( { class => $self->class, id => $self->id } );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:

