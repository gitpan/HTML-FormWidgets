# @(#)$Id: Template.pm 334 2011-12-12 04:30:18Z pjf $

package HTML::FormWidgets::Template;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.8.%d', q$Rev: 334 $ =~ /\d+/gmx );
use parent q(HTML::FormWidgets);

use English qw(-no_match_vars);
use File::Spec;
use IO::File;

sub render_field {
   my ($self, $args) = @_;

   my $path = File::Spec->catfile( $self->options->{template_dir},
                                   $self->name.q(.tt) );

   -f $path or return "Path $path not found";

   my $rdr = IO::File->new( $path, q(r) ) or return "Path $path cannot read";

   my $content = do { local $RS = undef; <$rdr> }; $rdr->close();
   my $id      = $self->id;

   return "[% ref = template_data.${id}; %]\n${content}";
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
