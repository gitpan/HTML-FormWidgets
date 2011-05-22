# @(#)$Id: Note.pm 275 2010-08-02 17:56:49Z pjf $

package HTML::FormWidgets::Note;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.6.%d', q$Rev: 275 $ =~ /\d+/gmx );
use parent qw(HTML::FormWidgets);

__PACKAGE__->mk_accessors( qw(width) );

sub init {
   my ($self, $args) = @_;

   $self->class    ( q(note) );
   $self->container( 0       );
   $self->sep      ( q()     );
   $self->width    ( undef   );
   return;
}

sub render_field {
   my ($self, $args) = @_;

   $args = { class => $self->class, id => $self->id };
   $self->align and $args->{style} .= 'text-align: '.$self->align.q(;);
   $self->width and $args->{style} .= ' width: '.$self->width.q(;);

   (my $text = $self->text || $self->loc( $self->name )) =~ s{ \A \n }{}msx;

   return $self->hacc->span( $args, $text );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
