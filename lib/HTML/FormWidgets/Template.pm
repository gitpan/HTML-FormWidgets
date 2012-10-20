# @(#)$Id: Template.pm 377 2012-10-20 14:52:32Z pjf $

package HTML::FormWidgets::Template;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.15.%d', q$Rev: 377 $ =~ /\d+/gmx );
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
