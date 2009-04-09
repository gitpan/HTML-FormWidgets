package HTML::FormWidgets::Password;

# @(#)$Id: Password.pm 154 2009-04-09 17:04:48Z pjf $

use strict;
use warnings;
use parent qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.4.%d', q$Rev: 154 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(subtype width) );

sub _init {
   my ($self, $args) = @_;

   $self->subtype( undef );
   $self->width(   20 );
   return;
}


sub _render {
   my ($self, $args) = @_; my $html;

   $args->{size} = $self->width;
   $html         = $self->hacc->password_field( $args );

   return $html unless ($self->subtype && $self->subtype eq q(verify));

   $html .= $self->loc( q(vPasswordPrompt) );
   $args->{name} =~ s{ 1 }{2}mx; $args->{id} =~ s{ 1 }{2}mx;
   $html .= $self->hacc->password_field( $args );
   return $html;
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
