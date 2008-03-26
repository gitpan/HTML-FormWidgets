package HTML::FormWidgets::Chooser;

# @(#)$Id: Chooser.pm 28 2008-03-26 15:33:59Z pjf $

use strict;
use warnings;
use base qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 28 $ =~ /\d+/gmx );

sub _render {
   my ($me, $ref) = @_; my $onclick;

   $onclick  = 'return submitObj.Chooser(';
   $onclick .= 'document.forms[0].'.$me->field.'.value, ';
   $onclick .= 'document.forms[0], ';
   $onclick .= '\''.$me->key.'\', ';
   $onclick .= '\''.$me->href.'\', ';
   $onclick .= '\'width='.$me->width.', screenX=0, ';
   $onclick .= 'height='.$me->height.', screenY=0, ';
   $onclick .= 'dependent=yes, titlebar=no, scrollbars=yes\')';
   $ref->{onclick} = $onclick;
   $ref->{value}   = $me->button;

   push @{ $me->hide }, { name => q(_verb), value => q() };

   return $me->elem->submit( $ref );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
