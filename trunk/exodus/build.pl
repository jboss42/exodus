#!/bin/perl -w

use strict;

$::D = 'f:/lang/Delphi7';
$::TNT = "D:\\src\\exodus\\exodus\\components\\tntUnicode";
$::ICQ = "\"D:\\src\\exodus\\exodus\\plugins\\ICQ-Import\\ICQ\\Component\"";
$::NSIS = "\"D:\\Program Files\\NSIS\\makensis.exe\"";
$::DXGETDIR = "F:\\lang\\dxgettext";
do "dopts.pl";
$::MSGFMT = "$::DXGETDIR\\msgfmt.exe";
$::DXGETTEXT = "$::DXGETDIR\\dxgettext.exe";

my $DD;
($DD = $::D) =~ s/\//\\/g;
my $imports = "\"$DD\\Imports\"";
my $dcc = "\"$::D/Bin/dcc32.exe\"";
my $rcc = "\"$::D/Bin/brcc32.exe\"";
my $opts = "-B -Q -DExodus -U\"$DD\\Lib\"";
my $comp = "..\\..\\Components";
my $plugopts = "$opts -U\"$comp\" -U\"$::TNT\"";

my $rtype = "release";
if ($#ARGV >= 0) {
  if ($ARGV[0] eq "daily") {
	$rtype = "daily";
  } elsif ($ARGV[0] eq "help") {
	print <<EOF;
USAGE:
build.pl [daily]
   defaults to release.
EOF
	exit(64);
  }
}

unlink "setup.exe";
unlink "Exodus.exe";
grep unlink, glob("output/*.dcu"); # rm *.dcu

e("$dcc $opts -Noutput IdleHooks.dpr");
e("$rcc version.rc");
e("$rcc xml.rc");
e("$dcc $opts -Noutput -U\"$::TNT\" Exodus.dpr");

e("$::DXGETTEXT *.pas *.inc *.rc *.dpr *.xfm *.dfm prefs\\*.pas prefs\\*.inc prefs\\*.rc prefs\\*.dpr prefs\\*.xfm prefs\\*.dfm ..\\jopl\\*.pas ..\\jopl\\*.inc ..\\jopl\\*.rc ..\\jopl\\*.dpr ..\\jopl\\*.xfm ..\\jopl\\*.dfm");

unlink "locale.zip";
grep unlink, glob("locale/*/LC_MESSAGES/default.mo");
grep &msgfmt, glob("locale/*/LC_MESSAGES/default.po");
e('zip locale ' . join(' ', glob("locale/*/LC_MESSAGES/default.mo")));

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
if ($rtype eq "daily") {
  e("$::NSIS /v1 /DDAILY exodus.nsi");
} else {
  e("$::NSIS /v1 exodus.nsi");
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
          RegDll "\$INSTDIR\\plugins\\$base.dll"
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

sub msgfmt() {
  my $po = $_;
  (my $mo = $po) =~ s/po$/mo/;
  
  e("$::MSGFMT $po -o $mo");
}
