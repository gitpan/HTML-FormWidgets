# @(#)$Id: Checkbox.pm 347 2012-03-09 14:58:00Z pjf $

package HTML::FormWidgets::Checkbox;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.11.%d', q$Rev: 347 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(checked label_class labels value) );

sub init {
   my ($self, $args) = @_;

   $self->checked        ( 0 );
   $self->container_class( q(checkbox_container) );
   $self->label_class    ( q(checkbox_label) );
   $self->labels         ( {} );
   $self->value          ( 1 );
   return;
}

sub render_field {
   my ($self, $args) = @_; my $hacc = $self->hacc;

   $self->checked and $args->{checked} = $self->is_xml ? q(checked) : undef;
   $args->{value} = $self->value;

   my $html  = $hacc->checkbox( $args );
   my $label = exists $self->labels->{ $self->value }
                    ? $self->labels->{ $self->value } : undef;

   $label and $html .= $hacc->span( { class => $self->label_class }, $label );

   return $html;
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
