#!/bin/perl -w

use strict;

$::D = 'f:/lang/Delphi7';
$::TNT = "D:\\src\\exodus\\exodus\\components\\tntUnicode";
$::ICQ = "\"D:\\src\\exodus\\exodus\\plugins\\ICQ-Import\\ICQ\\Component\"";

do "dopts.pl";

my $DD;
($DD = $::D) =~ s/\//\\/g;
my $imports = "\"$DD\\Imports\"";
my $dcc = "\"$::D/Bin/dcc32.exe\"";
my $rcc = "\"$::D/Bin/brcc32.exe\"";
my $opts = '-B -Q';
my $comp = "..\\..\\Components";
my $plugopts = "$opts -U\"$comp\" -U\"$::TNT\"";

e("$dcc $opts -Noutput IdleHooks.dpr");
e("$rcc version.rc");
e("$dcc $opts -Noutput -U\"$::TNT\" Exodus.dpr");

chdir "plugins";
grep unlink, glob("*.zip"); # rm *.zip
grep unlink, glob("*.dll"); # rm *.dll

# for each non-CVS directory
my $f;
for (glob("*")) {
  next unless -d;
  next if /^CVS$/;
  print "$_\n";
  plug($_);
}

print "SUCCESS!!!\n";

sub e {
  my $cmd = shift;
  print "$cmd\n";
  system $cmd and exit;
}

sub plug {
  my $p = shift;
  chdir $p or die;

  my $dpr = (glob("*.dpr"))[0];
  unless ($dpr) { chdir ".."; return };

  my $thisopts = $plugopts;
  if ($p =~ /ICQ/) { $thisopts .= " -U$::ICQ"; }
  
  e("$dcc $thisopts -E.. -Noutput -U$imports $dpr");
  chdir "..";
  (my $dll = $dpr) =~ s/\.dpr$/.dll/;
  (my $zip = $dpr) =~ s/\.dpr$/.zip/;
  e("zip -9 $zip $dll");
}
