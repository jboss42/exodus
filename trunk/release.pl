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

my $urtype = uc($::RTYPE);
my $cl = "ChangeLog-$urtype.txt";
e("perl build.pl $::RTYPE");
e("$::CVS ci -m \"$::RTYPE build\" exodus/version.h exodus/version.nsi exodus/default.po") if $::CVS;

e("perl cvs2cl.pl --delta $urtype:HEAD -f $cl");
e("$::CVS tag -F $urtype") if $::CVS;

chdir "exodus" or die;
if ($::RTYPE eq "daily") {
  e("$::SCP ../$cl setup.exe Exodus.zip plugins/*.zip $userhost:$::ROOT/www/daily/stage");
  e("$::SSH $userhost \"cd $::ROOT/www/daily/stage; chmod 644 *; mv setup.exe $cl ..; mv Exodus.zip ..; mv *.zip ../plugins\"");
} else {
  my $uver;
  ($uver = $version) =~ s/\./_/g;
  e("$::CVS tag -F v_$uver") if $::CVS;
  e("$::SCP setup.exe $userhost:$::ROOT/files/exodus_$version.exe");
  e("$::SCP plugins/*.zip $userhost:$::ROOT/www/plugins");
  e("$::SCP ../$cl $userhost:$::ROOT/www");
  e("$::SSH $userhost \"chmod 644 $::ROOT/files/exodus_$version.exe $::ROOT/www/plugins/*.zip $::ROOT/www/$cl\"");
}

print "\n\nSUCCESS!\n";

sub e {
  my $cmd = shift;
  print "$cmd\n";
  system $cmd and exit;
}
