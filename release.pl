#!/bin/perl -w

use strict;
#$::USER = 'hildjj@jabberstudio.org';
$::USER = 'pgmillard@jabberstudio.org';

#$::SCP = 'scp -C';
#$::SSH = 'ssh';
$::SCP = 'pscp';
$::SSH = 'plink';

do "dopts.pl";

my $rtype = "daily";
my $vtype = "build";
if ($#ARGV >= 0) {
  if ($ARGV[0] eq "release") {
	$rtype = "release";
	$vtype = "sp";
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
	$vtype = $ARGV[1];
  }
}


print "$rtype build (version $vtype)...\n";

chdir "exodus" or die;

my $version = `perl version.pl $vtype`;
$? and exit(1);
chomp $version;

print "$version\n";

e("perl build.pl $rtype");
e("cvs ci -m \"$rtype build\" version.h version.nsi default.po");
chdir ".." or die;
e("cvs tag -F " . uc($rtype));
chdir "exodus" or die;
if ($rtype eq "daily") {
  e("$::SCP setup.exe Exodus.zip plugins/*.zip $::USER:/var/projects/exodus/www/daily/stage");
  e("$::SSH $::USER \"cd /var/projects/exodus/www/daily/stage; chmod 644 *; mv setup.exe ..; mv Exodus.zip ..; mv *.zip ../plugins\"");
} else {
  e("$::SCP setup.exe $::USER:/var/projects/exodus/files/exodus_$version.exe");
  e("$::SCP plugins/*.zip $::USER:/var/projects/exodus/www/plugins");
  e("$::SSH $::USER \"chmod 644 /var/projects/exodus/files/exodus_$version.exe /var/projects/exodus/www/plugins/*.zip\"");
}

print "\n\nSUCCESS!\n";

sub e {
  my $cmd = shift;
  print "$cmd\n";
  system $cmd and exit;
}
