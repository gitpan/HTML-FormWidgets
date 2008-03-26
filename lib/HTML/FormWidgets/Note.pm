package HTML::FormWidgets::Note;

# @(#)$Id: Note.pm 24 2008-03-20 13:57:08Z pjf $

use strict;
use warnings;
use base qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 24 $ =~ /\d+/gmx );

sub _render {
   my ($me, $ref) = @_; my $text;

   $ref           = { class => q(note) };
   $ref->{style} .= 'text-align: '.$me->align.q(;) if ($me->align);
   $ref->{style} .= ' width: '.$me->width.q(;)     if ($me->width);

   ($text = $me->msg( $me->name ) || $me->text || q()) =~ s{ \A \n }{}msx;

   return $me->elem->div( $ref, $text );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
