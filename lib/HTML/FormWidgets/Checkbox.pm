package HTML::FormWidgets::Checkbox;

# @(#)$Id: Checkbox.pm 83 2008-09-24 00:27:50Z pjf $

use strict;
use warnings;
use base qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.2.%d', q$Rev: 83 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(checked label_class labels value) );

sub init {
   my ($self, $args) = @_;

   $self->checked(     0 );
   $self->label_class( q(note) );
   $self->labels(      {} );
   $self->value(       1 );

   $self->NEXT::init( $args );
   return;
}

sub _render {
   my ($self, $args)  = @_;

   $args->{checked} = q(checked) if ($self->checked);
   $args->{value  } = $self->value;

   my $html  = $self->hacc->checkbox( $args );
   my $label = exists $self->labels->{ $self->value }
                    ? $self->labels->{ $self->value } : undef;

   if ($label) {
      $html .= $self->hacc->span( { class => $self->label_class }, $label );
   }

   return $html;
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
