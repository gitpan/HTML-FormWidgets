package HTML::FormWidgets::Template;

# @(#)$Id: Template.pm 154 2009-04-09 17:04:48Z pjf $

use strict;
use warnings;
use parent qw(HTML::FormWidgets);
use English qw(-no_match_vars);
use File::Spec;
use IO::File;

use version; our $VERSION = qv( sprintf '0.4.%d', q$Rev: 154 $ =~ /\d+/gmx );

__PACKAGE__->mk_accessors( qw(templatedir) );

sub _init {
   my ($self, $args) = @_;

   $self->templatedir( undef );
   return;
}

sub _render {
   my ($self, $args) = @_; my ($content, $path, $rdr);

   $path = File::Spec->catfile( $self->templatedir, $self->id.q(.tt) );

   return 'Not found '.$path   unless (-f $path);
   return 'Cannot read '.$path unless ($rdr = IO::File->new( $path, q(r) ));

   $content = do { local $RS = undef; <$rdr> }; $rdr->close();

   return $content;
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
