package HTML::FormWidgets::Table;

# @(#)$Id: Table.pm 26 2008-03-24 19:14:41Z pjf $

use strict;
use warnings;
use base qw(HTML::FormWidgets);

use version; our $VERSION = qv( sprintf '0.1.%d', q$Rev: 26 $ =~ /\d+/gmx );

sub _render {
   my ($me, $ref) = @_; my ($fld, $r_no, $rows, $text, $text1, $tip, $val);

   my $cells      = q();
   my $c_no       = 0;
   my $def_class  = $me->class || q(small table);
   my $data       = $me->data  || { flds => [], values => [] };
   my $htag       = $me->elem;

   $me->select( q() ) unless (defined $me->select);

   if ($me->select eq q(left)) {
      $ref           = { class => $def_class };
      $ref->{class} .= $me->edit ? q( select) : q( minimal);
      $cells        .= $htag->th( $ref, 'Select' );
   }

   for $fld (@{ $data->{flds} }) {
      $ref = { class => $def_class };

      if (exists $data->{hclass}->{ $fld }) {
         next if ($data->{hclass}->{ $fld } eq q(hide));

         $ref->{class} .= q( ).$data->{hclass}->{ $fld };
      }

      $ref->{class} .= q( nowrap) unless (exists $data->{wrap}->{ $fld });
      $cells        .= $htag->th( $ref, $data->{labels}->{ $fld } );
      $c_no++;
   }

   if ($me->select eq q(right)) {
      $ref           = { class => $def_class };
      $ref->{class} .= $me->edit ? q( select) : q( minimal);
      $cells        .= $htag->th( $ref, 'Select' );
   }

   $rows = $htag->tr( $cells ); $r_no = 0;

   for $val (@{ $data->{values} }) {
      $cells = q(); $c_no = 0;

      if ($me->select eq q(left) and $data->{values}->[0]) {
         $cells .= $me->_checkBox( $r_no, $c_no, $val );
      }

      for $fld (@{ $data->{flds} }) {
         if ($me->edit) {
            $ref              = {};
            $ref->{default  } = $val->{ $fld };
            $ref->{maxlength} = $data->{maxlengths}->{ $fld }
               if (exists $data->{maxlengths}->{ $fld });
            $ref->{name     } = $fld.$r_no;
            $ref->{size     } = exists $data->{sizes}->{ $fld }
                              ? $data->{sizes}->{ $fld } : 10;
            $text             = $htag->textfield( $ref );
            $ref              = { class => q(dataValue) };
            $ref->{class}    .= q( nowrap)
               unless (exists $data->{wrap}->{ $fld });
            $cells           .= $htag->td( $ref, $text );
         }
         else {
            next if ($data->{hclass}->{ $fld }
                     and $data->{hclass}->{ $fld } eq q(hide));

            $ref              = {};
            $ref->{align}     = exists $data->{align}->{ $fld }
                              ? $data->{align}->{ $fld } : q(left);

            if ($val->{class} and exists $val->{class}->{ $fld }) {
               $ref->{class}  = $val->{class}->{ $fld };
            } else {
               $ref->{class}  = $c_no % 2 == 0 ? q(even) : q(odd);
               $ref->{class} .= q( ).($data->{class} || q(dataValue));
            }

            $ref->{class}    .= q( nowrap)
               unless (exists $data->{wrap}->{ $fld });
            $cells .= $htag->td( $ref, $val->{ $fld } || q(&nbsp;) )."\n";
         }

         $c_no++;
      }

      if ($me->select eq q(right) and $data->{values}->[0]) {
         $cells .= $me->_checkBox( $r_no, $c_no, $val );
      }

      $ref   = { id => q(row).$me->name.$r_no };
      $rows .= $htag->tr( $ref, $cells ); $r_no++;
   }

   push @{ $me->hide }, { name => q(nRows).$me->name, value => $r_no };

   if ($me->edit) {
      $cells = q();

      for $c_no (0 .. $#{ $data->{flds} }) {
         $fld              = $data->{flds}->[ $c_no ];
         $ref              = { id => q(add).$me->name.$c_no };
         $ref->{maxlength} = $data->{maxlengths}->{ $fld }
            if (exists $data->{maxlengths}->{ $fld });
         $ref->{name     } = $fld;
         $ref->{size     } = exists $data->{sizes}->{ $fld }
                           ? $data->{sizes}->{ $fld } : 10;
         $text             = $htag->textfield( $ref );
         $cells           .= $htag->td( $text );
      }

      $ref            = {};
      $ref->{class  } = $ref->{name} = q(button);
      $ref->{onclick} = 'return tableObj.AddTableRow(\''.$me->name.'\', 1)';
      $ref->{src    } = $me->assets.'AddItem.png';
      $ref->{value  } = q(add).(ucfirst $me->name);
      $text           = $htag->image_button( $ref );
      $tip            = 'Enter a new item into the adjacent text ';
      $tip           .= 'fields and then click this button to add ';
      $tip           .= 'it to the list';
      $ref            = { class => q(help tips), title => $tip };
      $text           = $htag->span( $ref, $text );

      if ($me->select) {
         $ref            = {};
         $ref->{class  } = $ref->{name} = q(button);
         $ref->{onclick} = 'return tableObj.RemoveTableRow(\''.$me->name.'\')';
         $ref->{src    } = $me->assets.'RemoveItem.png';
         $ref->{value  } = q(remove).(ucfirst $me->name);
         $text1          = $htag->image_button( $ref );
         $tip            = 'Select one or more items from the ';
         $tip           .= 'above list and then click this button ';
         $tip           .= 'to remove them';
         $ref            = { class => q(help tips), title => $tip };
         $text          .= $htag->span( $ref, $text1 );
      }

      $cells .= $htag->td( $text );
      $rows  .= $htag->tr( { id => q(add).$me->name }, $cells );
   }

   return $htag->table( { class => ($me->prompt ? q(form) : q(std))}, $rows );
}

# Private methods

sub _checkBox {
   my ($me, $r_no, $c_no, $val) = @_; my ($text, $ref);

   $ref  = { name => 'select'.$me->name.$r_no };
   $ref->{value} = $val->{id} if ($val->{id});
   $text = $me->elem->checkbox( $ref );
   $ref  = { align => 'center', class => ($c_no % 2 == 0 ? 'even' : 'odd') };
   return $me->elem->td( $ref, $text );
}

1;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
