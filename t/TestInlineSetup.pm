use strict; use warnings;
package TestInlineSetup;

use diagnostics;
use File::Path;
use File::Spec;

sub import {
    my ($package, $option) = @_;
    $option ||= '';
}

BEGIN {
  if (exists $ENV{PERL_INSTALL_ROOT}) {
    warn "\nIgnoring \$ENV{PERL_INSTALL_ROOT} in $0\n";
    delete $ENV{PERL_INSTALL_ROOT};
  }
  # Suppress "Set up gcc environment ..." warning.
  # (Affects ActivePerl only.)
  $ENV{ACTIVEPERL_CONFIG_SILENT} = 1;
}

our $DIR;
BEGIN {
    ($_, $DIR) = caller(2);
    $DIR =~ s/.*?(\w+)\.t$/$1/ or die;
    $DIR = "_Inline_$DIR.$$";
    rmtree($DIR) if -d $DIR;
    mkdir($DIR) or die "$DIR: $!\n";
}
my $absdir = File::Spec->rel2abs($DIR);

my $startpid = $$;
END {
    rmtree($absdir) if $$ == $startpid; # only when original process exits
}

1;
