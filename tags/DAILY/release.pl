#!/bin/perl -w

use strict;
# publish server
$::USER = 'hildjj';
$::SERVER = 'jabberstudio.org';
$::ROOT = '/var/projects/exodus';

$::SCP = 'scp -C';
$::SSH = 'ssh';
$::SVN = 'svn';
$::RTYPE = "daily";
$::VTYPE = "build";
$::PREFIX = "svn+putty";
$::SVNROOT = "/var/projects/exodus/svn";

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

my $oldrev;
if ($::RTYPE eq "daily") {
} else {
}

print "$version\n";
chdir ".." or die;

my $urtype = uc($::RTYPE);
e("perl build.pl $::RTYPE");
e("$::SVN ci -m \"$::RTYPE build\" exodus/version.h exodus/version.nsi exodus/default.po") if $::SVN;

#e("$::SVN tag -F $urtype") if $::SVN;
e("$::SVN del $::PREFIX://$::USER@$::SERVER$SVNROOT/tags/DAILY -m \"new build.\"") if $::SVN;
e("$::SVN cp . $::PREFIX://$::USER@$::SERVER$SVNROOT/tags/DAILY -m \"new build.\"") if $::SVN;

chdir "exodus" or die;
if ($::RTYPE eq "daily") {
  $oldrev = `type daily-rev`;
  $? and exit(1);
  chomp $oldrev;
  e("$::SCP setup.exe Exodus.zip plugins/*.zip $userhost:$::ROOT/www/daily/stage");
  e("$::SSH $userhost \"cd $::ROOT/www/daily/stage; chmod 664 *; mv setup.exe ..; mv Exodus.zip ..; mv *.zip ../plugins\; /var/projects/exodus/bin/genlog $oldrev daily\"");
} else {
  my $uver;
  $oldrev = `type release-rev`;
  $? and exit(1);
  chomp $oldrev;
  ($uver = $version) =~ s/\./_/g;
  e("$::SVN tag -F v_$uver") if $::SVN;
  e("$::SCP setup.exe $userhost:$::ROOT/files/exodus_$version.exe");
  e("$::SCP setup-standalone.exe $userhost:$::ROOT/files/exodus_standalone_$version.exe");
  e("$::SCP exodus.zip $userhost:$::ROOT/files/exodus_$version.zip");
  e("$::SCP plugins/*.zip $userhost:$::ROOT/www/plugins");
  e("$::SSH $userhost \"chmod 664 $::ROOT/files/exodus_$version.exe $::ROOT/www/plugins/*.zip ; /var/projects/exodus/bin/genlog $oldrev release\"");
}

print "\n\nSUCCESS!\n";

sub e {
  my $cmd = shift;
  print "$cmd\n";
  system $cmd and exit;
}
