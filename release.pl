#!/bin/perl -w

use strict;
# publish server
$::USER = 'hildjj';
$::SERVER = 'jabberstudio.org';
$::ROOT = '/var/projects/exodus';

$::SCP = 'scp -C';
$::SSH = 'ssh';
$::CVS = 'cvs';

$::RTYPE = "daily";
$::VTYPE = "build";

do "dopts.pl";

my $userhost = $::USER ? "$::USER\@$::SERVER" : $::SERVER;

if ($#ARGV >= 0) {
  if ($ARGV[0] eq "release") {
	$::RTYPE = "release";
	$::VTYPE = "sp";
  } elsif ($ARGV[0] eq "help") {
	print <<EOF;
USAGE:
release.pl [release] [maj|min|sp|build]
   defaults to daily.
   if daily, version is build.
   if release, version default is sp.
EOF
	exit(64);
  }

  if ($#ARGV >= 1) {
	$::VTYPE = $ARGV[1];
  }
}


print "$::RTYPE build (version $::VTYPE)...\n";

chdir "exodus" or die;

my $version = `perl version.pl $::VTYPE`;
$? and exit(1);
chomp $version;

print "$version\n";
chdir ".." or die;

e("perl build.pl $::RTYPE");
e("$::CVS ci -m \"$::RTYPE build\" exodus/version.h exodus/version.nsi exodus/default.po") if $::CVS;
e("$::CVS tag -F " . uc($::RTYPE)) if $::CVS;

chdir "exodus" or die;
if ($::RTYPE eq "daily") {
  e("$::SCP setup.exe Exodus.zip plugins/*.zip $userhost:$::ROOT/www/daily/stage");
  e("$::SSH $userhost \"cd $::ROOT/www/daily/stage; chmod 644 *; mv setup.exe ..; mv Exodus.zip ..; mv *.zip ../plugins\"");
} else {
  e("$::SCP setup.exe $userhost:$::ROOT/files/exodus_$version.exe");
  e("$::SCP plugins/*.zip $userhost:$::ROOT/www/plugins");
  e("$::SSH $userhost \"chmod 644 $::ROOT/files/exodus_$version.exe $::ROOT/www/plugins/*.zip\"");
}

print "\n\nSUCCESS!\n";

sub e {
  my $cmd = shift;
  print "$cmd\n";
  system $cmd and exit;
}
