#! /usr/bin/perl -w

use Term::ANSIColor;
use IPC::Open3;

sub initDefaults
{
   $colors{"srcColor"} = color("reset");
   $colors{"introColor"} = color("reset");

   $colors{"warningFileNameColor"} = color("yellow");
   $colors{"warningNumberColor"}   = color("yellow");
   $colors{"warningMessageColor"}  = color("yellow");

   $colors{"errorFileNameColor"} = color("bold yellow");
   $colors{"errorNumberColor"}   = color("bold yellow");
   $colors{"errorMessageColor"}  = color("bold red");
}

sub srcscan
{
# Usage: srcscan($text, $normalColor)
#    $text -- the text to colorize
#    $normalColor -- The escape sequence to use for non-source text.

# Looks for text between ` and ', and colors it srcColor.

   my($line, $normalColor) = @_;

   my($srcon) = color("reset") . $colors{"srcColor"};
   my($srcoff) = color("reset") . $normalColor;

   $line = $normalColor . $line;

   # This substitute replaces `foo' with `AfooB' where A is the escape
   # sequence that turns on the the desired source color, and B is the
   # escape sequence that returns to $normalColor.
   $line =~ s/\`(.*?)\'/\`$srcon$1$srcoff\'/g;

   print($line, color("reset"));
}



initDefaults();


while(<STDIN>)
{
   if (m/^(.*?):([0-9]+):(.*)$/) # filename:lineno:message
   {
      $field1 = $1 || "";
      $field2 = $2 || "";
      $field3 = $3 || "";
      

      if ($field3 =~ m/\s+warning:.*/)
      {
        # Warning
        print($colors{"warningFileNameColor"}, "$field1:", color("reset"));
        print($colors{"warningNumberColor"}, "$field2:", color("reset"));
        srcscan($field3, $colors{"warningMessageColor"});
      }
      elsif($field3 =~ m/\s+error:.*/) 
      {
        # Error
        print($colors{"errorFileNameColor"}, "$field1:", color("reset"));
        print($colors{"errorNumberColor"}, "$field2:", color("reset"));
        srcscan($field3, $colors{"errorMessageColor"});
        printf("\n");
      }
      else
      {
        print(color("reset"), "$field1 $field2 $field3");
      }
      print("\n");
   }
   elsif (m/^(.*?):(.+):$/) # filename:message:
   {
      # No line number, treat as an "introductory" line of text.
      srcscan($_, $colors{"introColor"});
   }
   else # Anything else.        
   {
      # Doesn't seem to be a warning or an error. Print normally.
      print(color("reset"), $_);
   }
}




