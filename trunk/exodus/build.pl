#!/bin/perl -w

use strict;

$::D = 'f:/lang/Delphi7';
$::TNT = "D:\\src\\exodus\\exodus\\components\\tntUnicode";
$::ICQ = "\"D:\\src\\exodus\\exodus\\plugins\\ICQ-Import\\ICQ\\Component\"";
$::NSIS = "\"D:\\Program Files\\NSIS\\makensis.exe\"";

do "dopts.pl";

my $DD;
($DD = $::D) =~ s/\//\\/g;
my $imports = "\"$DD\\Imports\"";
my $dcc = "\"$::D/Bin/dcc32.exe\"";
my $rcc = "\"$::D/Bin/brcc32.exe\"";
my $opts = "-B -Q -DExodus -U\"$DD\\Lib\"";
my $comp = "..\\..\\Components";
my $plugopts = "$opts -U\"$comp\" -U\"$::TNT\"";

unlink "setup.exe";
unlink "Exodus.exe";
grep unlink, glob("output/*.dcu"); # rm *.dcu

e("$dcc $opts -Noutput IdleHooks.dpr");
e("$rcc version.rc");
e("$dcc $opts -Noutput -U\"$::TNT\" Exodus.dpr");

chdir "plugins";
grep unlink, glob("*.zip"); # rm *.zip
grep unlink, glob("*.dll"); # rm *.dll

open OFF,">plugin-off.nsi" or die $!;
open SEC,">plugin-sections.nsi" or die $!;
open DESC,">plugin-desc.nsi" or die $!;
open EN,">plugin-en.nsi" or die $!;

# for each non-CVS directory
my $f;
for (glob("*")) {
  next unless -d;
  next if /^CVS$/;
  print "$_\n";
  plug($_);
}

close OFF;
close SEC;
close DESC;
close EN;

chdir "..";
e("$::NSIS /v1 exodus.nsi");

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

  (my $base = $dpr) =~ s/\.dpr$//;
  (my $bare = $base) =~ s/^Ex//;

  e("$dcc $thisopts -U$imports -E.. -N.\\\\output $dpr");

  print OFF <<"EOF";
	Push \${SEC_$base}
	Call TurnOff

EOF

  my $size = -s("../$base.dll");
  $size = int $size / 1024;
  print SEC <<"EOF";
	Section "$bare" SEC_$base
	  AddSize $size
	  Push "$base"
	  Call DownloadPlugin
	SectionEnd
	
EOF

  print DESC <<"EOF";
  !insertmacro MUI_DESCRIPTION_TEXT \${SEC_$base} \$(DESC_$base)
EOF

  my $readme = `cat README.txt`;
  print EN <<"EOF";
LangString DESC_$base \${LANG_ENGLISH} "$readme"

EOF
  
  chdir "..";
  e("zip -9 $base.zip $base.dll");
}
